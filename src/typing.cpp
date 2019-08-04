/* Trying.io
*
* This file is part of the Trying.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/

#include "typing.hpp"

Typing::Typing() {
    connect(m_timer_0, SIGNAL(timeout()),
          this, SLOT(timerSlot_0()));
    m_timer_0->moveToThread(&m_qThread_0); // Changes the thread affinity for timer (m_timer_0) and its children
    m_timer_0->connect(&m_qThread_0, SIGNAL(started()), SLOT(start()));
    m_timer_0->connect(&m_qThread_0, SIGNAL(finished()), SLOT(stop()));
    m_timer_0->setInterval(1000); // 1000 ms equivalent to 1 second.
    m_timer_0->stop();

    connect(m_timer_1, SIGNAL(timeout()),
          this, SLOT(timerSlot_1()));
    m_timer_1->moveToThread(&m_qThread_1);
    m_timer_1->connect(&m_qThread_1, SIGNAL(started()), SLOT(start()));
    m_timer_1->connect(&m_qThread_1, SIGNAL(finished()), SLOT(stop()));
    m_timer_1->setInterval(250);
    m_timer_1->stop();

    connect(m_timer_2, SIGNAL(timeout()),
          this, SLOT(timerSlot_2()));
    m_timer_2->moveToThread(&m_qThread_2);
    m_timer_2->connect(&m_qThread_2, SIGNAL(started()), SLOT(start()));
    m_timer_2->connect(&m_qThread_2, SIGNAL(finished()), SLOT(stop()));
    m_timer_2->setInterval(250);
    m_timer_2->stop();

    initLanguageTable();
}

Typing::~Typing() {
    endTimers();
    freePtr();
}

void Typing::timerSlot_0() {

    // To count elapsed time.
    m_triggerCount++;
}

void Typing::timerSlot_1() {

    // To end timers when the elapsed time equal to the end time.
    if (m_triggerCount >= m_timeDuration) {
        m_userPro->setIsEndTest(true);
        endTimers();
    }
}

void Typing::timerSlot_2() {

    // Update Time Label with remaining time.
    int remainingTime = m_timeDuration - m_triggerCount;
    m_timeLabel->setProperty("text", remainingTime);

    // calculate user speed and update user speed label with his speed.
    calcUserSpeed();
    m_userSpeedLabel->setProperty("text", m_userSpeed);
}

void Typing::saveFile(QString name, QString lang, QString codeText) {
    saveFile(name, lang, codeText, m_saveFolder->getFullPath());
}

void Typing::saveFile(QString name, QString lang, QString codeText, QString path) {
    TFile newFile(name, lang, path);
    newFile.setContent(codeText);
    newFile.saveFile();
}

void Typing::loadFile() {
    m_selectedFile->loadAll();
    m_codeText = m_selectedFile->getContent();
}

QString Typing::getLnag() {
    return m_languageTable[m_selectedFile->getExtension()];;
}

QString Typing::getCodeText() {
    return m_codeText;
}

// returns string that has all info about user result.
QString Typing::getResult() {
    m_result = QString();
    m_result += "Typing Speed: " + QString::number(m_userSpeed) + " word per minutes.\n\n";
    m_result += "Number of Errors: " + QString::number(m_charMistakeCounter.size()) + "\n\n";
    if (m_charMistakeCounter.size()) {
        m_result += "List of Errors:\n\n";
        for (auto it = m_charMistakeCounter.begin(); it != m_charMistakeCounter.end(); it++) {
            m_result += it.key();
            m_result += ": Number of mistakes " + QString::number(it.value()) + "\n";
        }
    }

    return m_result;
}

QObject *Typing::getUserProgress() {
    return m_userProgress;
}

QObject *Typing::getSaveFolder() {
    return m_saveFolder;
}

int Typing::getTimeDuration() {
    return m_timeDuration;
}

bool Typing::isTested() {
    return m_selectedFile != nullptr;
}

void Typing::setTimeLabel(QObject *timeLabel) {
    m_timeLabel = timeLabel;
}

void Typing::setUserSpeedLabel(QObject *userSpeedLabel) {
    m_userSpeedLabel = userSpeedLabel;
}

void Typing::setSelectedFile(TFile *selectedFile) {
    m_selectedFile =selectedFile;
}

void Typing::setTimeDuration(int timeDurationInMinutes) {
    m_timeDuration = timeDurationInMinutes * MINUTE;
}

void Typing::startTimers() {
    m_triggerCount = 0;
    m_qThread_0.start();
    m_qThread_1.start();
    m_qThread_2.start();
}

void Typing::endTimers() {
    m_qThread_0.quit();
    m_qThread_0.wait();
    m_qThread_1.quit();
    m_qThread_1.wait();
    m_qThread_2.quit();
    m_qThread_2.wait();
}

void Typing::freePtr() {
    delete m_timer_0;
    delete m_timer_1;
    delete m_timer_2;
    delete m_saveFolder;
}

void Typing::updateUserProgress(QString typedText) {
    int startPoint = m_lengthOfTypedText;
    int endPoint = typedText.length();

    for (int index = startPoint; index < endPoint; index++) {
        if (typedText[index] != m_codeText[index]) {
            if (!m_userPro->isUserMadeMistake()) {
                m_userPro->setIsUserMadeMistake(true);
                m_userPro->setIndexOfFirstMistakeOfUser(index);
                m_charMistakeCounter[m_codeText[index]]++;

                m_lengthOfTypedText = m_userPro->getIndexOfFirstMistakeOfUser();
            }

            return;
        }
    }

    m_lengthOfTypedText = endPoint;
    m_userPro->setIsUserMadeMistake(false);

    // Determine if user finished the test or not.
    if (m_lengthOfTypedText == m_codeText.length()) {
        m_userPro->setIsEndTest(true);
        calcUserSpeed();

        return;
    }

    // To determine start and end of next word.
    determineNextWord(endPoint);
}

// Calculate user speed.
void Typing::calcUserSpeed() {
    long double speed = (static_cast<long double>(m_lengthOfTypedText) / static_cast<long double>(WORD_LENGTH))
            / (static_cast<long double>(m_triggerCount) / MINUTE);
    m_userSpeed = int(speed);
    if (speed - m_userSpeed > 0.499l) {
        m_userSpeed++;
    }
    if (m_userSpeed < 0) {
        m_userSpeed = 0;
    }
}

void Typing::initGlobalVarOfUserProgress() {
    m_charMistakeCounter.clear();
    m_userSpeed = 0;
    m_lengthOfTypedText = 0;
}

void Typing::initLanguageTable() {
    QString langList[] = {"C", "C++", "Java"};
    QList<QString> langEx[] = {{"c", "h"},
                               {"cc", "cpp", "cxx", "c++", "hh", "hpp", "hxx", "h++"},
                               {"java"}};

    for(int i = 0; i < 3; i++) {
        for (QList<QString>::Iterator it = langEx[i].begin(); it != langEx[i].end(); it++) {
            m_languageTable[*it] = langList[i];
        }
    }
}


void Typing::determineNextWord(int index) {
    if (m_codeText[index] == ' ' || m_codeText[index] == '\n') {
        m_userPro->setEndIndexOfNextWord(index + 1);
        m_userPro->setStartIndexOfNextWord(index);

        return;
    }

    for (int i = index; i >= 0; i--) {
        if (m_codeText[i] == '\n' || m_codeText[i] == ' ') {
            m_userPro->setStartIndexOfNextWord(i + 1);
            break;
        } else if (i == 0){
            m_userPro->setStartIndexOfNextWord(i);
        }
    }
    for (int i = index; i < m_codeText.length(); i++) {
        if (m_codeText[i] == '\n' || m_codeText[i] == ' ') {
            m_userPro->setEndIndexOfNextWord(i);
            break;
        } else if (i == m_codeText.length() - 1) {
            m_userPro->setEndIndexOfNextWord(i + 1);
        }
    }
}


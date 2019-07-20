/* Typing.io
*
* This file is part of the Typing.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/

#include "typing.hpp"

Typing::Typing() {
    connect(m_timer, SIGNAL(timeout()),
          this, SLOT(timerSlot()));
    m_timer->moveToThread(&m_qThread);
    m_timer->connect(&m_qThread, SIGNAL(started()), SLOT(start()));
    m_timer->connect(&m_qThread, SIGNAL(finished()), SLOT(stop()));
    m_timer->setInterval(500);
    m_timer->stop();
}

Typing::~Typing() {
    endTimer();
    freePtr();
}

void Typing::timerSlot() {
    m_triggerCount--;
    m_timeLabel->setProperty("text", m_triggerCount / 2 + (m_triggerCount & 1));
    if (!m_triggerCount) {
        m_qThread.quit();
        m_qThread.wait();
    }
}

bool Typing::save(QString lang, QString codeText) {
    m_lang = lang;
    m_codeText = codeText;
    return true;
}

QString Typing::getLnag() {
    return m_lang;
}

QString Typing::getCodeText() {
    return m_codeText;
}

// returns string that has all info about user result.
QString Typing::getResult() {
    m_result = QString();
    m_result += "Typing Speed: " + QString::number(m_userSpeed) + " word per minutes.\n\n";
    m_result += "Number of Errors: " + QString::number(m_mistakeCounter) + "\n\n";
    if (m_mistakeCounter) {
        m_result += "List of Errors:\n\n";
        int numberOfProcessedMistakes = 0;
        for (short i = 1; i < SIZE_OF_M_CHART_MISTAKE_COUNTER &&
             numberOfProcessedMistakes < m_mistakeCounter; i++) {
            if (m_charMistakeCounter[int(i)]) {
                m_result += char(i);
                m_result += ": Number of mistakes " + QString::number(m_charMistakeCounter[int(i)]) + "\n";
                numberOfProcessedMistakes++;
            }
        }
    }

    return m_result;
}

void Typing::setTimeLabel(QObject *timeLabel) {
    m_timeLabel = timeLabel;
}

void Typing::startTimer() {
    m_triggerCount = TIMER_START_POINT;
    m_qThread.start();
}

void Typing::endTimer() {
    m_qThread.quit();
    m_qThread.wait();
}

void Typing::freePtr() {
    delete m_timer;
}

QObject *Typing::getUserProgress() {
    return m_userProgress;
}

void Typing::updateUserProgress(QString typedText) {
    m_userPro->setIsEndTest(false);

    int startPoint = m_lengthOfTypedText;
    int endPonit = typedText.length();

    #include <algorithm>
    if (startPoint > endPonit) {
        std::swap(startPoint, endPonit);
    }

    for (int index = startPoint; index < endPonit; index++) {
        if (typedText[index] != m_codeText[index]) {
            if (!m_userPro->isUserMadeMistake()) {
                m_userPro->setIsUserMadeMistake(true);
                m_userPro->setIndexOfFirstMistakeOfUser(index);
                m_mistakeCounter++;
                m_charMistakeCounter[m_codeText[index].unicode()]++;

                // To determine start and end of first word that the user has mistake on it.
                if (m_codeText[index] == '\n' || m_codeText[index] == ' ') {
                    m_userPro->setStartIndexOfNextWord(index);
                    m_userPro->setEndIndexOfNextWord(index + 1);
                } else {
                    for (int i = index - 1; i >= 0; i--) {
                        if (m_codeText[i] == '\n' || m_codeText[i] == ' ') {
                            m_userPro->setStartIndexOfNextWord(i + 1);
                            break;
                        } else if (i == 0){
                            m_userPro->setStartIndexOfNextWord(i);
                        }
                    }

                    for (int i = index + 1; i < m_codeText.length(); i++) {
                        if (m_codeText[i] == '\n' || m_codeText[i] == ' ') {
                            m_userPro->setEndIndexOfNextWord(i);
                            break;
                        } else if (i == m_codeText.length() - 1) {
                            m_userPro->setEndIndexOfNextWord(i + 1);
                        }
                    }
                }

                m_lengthOfTypedText = m_userPro->getIndexOfFirstMistakeOfUser();
            }

            return;
        }
    }

    m_lengthOfTypedText = endPonit;
    m_userPro->setIsUserMadeMistake(false);

    // Determine if user would have finished the test or not.
    if (m_lengthOfTypedText == m_codeText.length()) {
        m_userPro->setIsEndTest(true);
        calcUserSpeed();

        return;
    }

    // To determine start and end of next word.
    if (m_codeText[endPonit] == ' ' || m_codeText[endPonit] == '\n') {
        m_userPro->setEndIndexOfNextWord(endPonit + 1);
        m_userPro->setStartIndexOfNextWord(endPonit);

        return;
    }
    for (int i = endPonit; i >= 0; i--) {
        if (m_codeText[i] == '\n' || m_codeText[i] == ' ') {
            m_userPro->setStartIndexOfNextWord(i + 1);
            break;
        } else if (i == 0){
            m_userPro->setStartIndexOfNextWord(i);
        }
    }
    for (int i = endPonit; i < m_codeText.length(); i++) {
        if (m_codeText[i] == '\n' || m_codeText[i] == ' ') {
            m_userPro->setEndIndexOfNextWord(i);
            break;
        } else if (i == m_codeText.length() - 1) {
            m_userPro->setEndIndexOfNextWord(i + 1);
        }
    }
}

// Calculate user speed.
void Typing::calcUserSpeed() {
    double speed = (double(m_lengthOfTypedText) / double(WORD_LENGTH))
            / (TIMER_START_POINT - m_triggerCount) * 120;
    m_userSpeed = int(speed);
    if (speed - m_userSpeed > 0.499) {
        m_userSpeed++;
    }
    if (m_userSpeed < 0) {
        m_userSpeed = 0;
    }
}

void Typing::initGlobalVarOfUserProgress() {
    for (int i = 0; i < SIZE_OF_M_CHART_MISTAKE_COUNTER; i++) {
        m_charMistakeCounter[i] = 0;
    }
    m_mistakeCounter = 0;
    m_userSpeed = 0;
    m_lengthOfTypedText = 0;
}

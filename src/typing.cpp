/* Typing.io
*
* This file is part of the Typing.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/

#include "typing.hpp"

#include <iostream>
using namespace std;

Typing::Typing() {
    connect(m_timer_0, SIGNAL(timeout()),
          this, SLOT(timerSlot_0()));
    m_timer_0->moveToThread(&m_qThread_0);
    m_timer_0->connect(&m_qThread_0, SIGNAL(started()), SLOT(start()));
    m_timer_0->connect(&m_qThread_0, SIGNAL(finished()), SLOT(stop()));
    m_timer_0->setInterval(250);
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
    if (m_triggerCount >= m_timerEndPoint) {
        m_userPro->setIsEndTest(true);
        endTimers();
    }
}

void Typing::timerSlot_2() {

    // Update Time Label wit remaining time.
    int remainingTime = m_timerEndPoint - m_triggerCount;
    m_timeLabel->setProperty("text", remainingTime / 4 + (remainingTime % 4 > 1));
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
        for (short i = 1; i < SIZE_OF_M_CHAR_MISTAKE_COUNTER &&
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

void Typing::startTimers() {
    m_triggerCount = 0;
    m_timerEndPoint = TIMER_END_POINT;
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
}

QObject *Typing::getUserProgress() {
    return m_userProgress;
}

void Typing::updateUserProgress(QString typedText) {
    m_userPro->setIsEndTest(false);

    int startPoint = m_lengthOfTypedText;
    int endPoint = typedText.length();

    #include <algorithm>
    if (startPoint > endPoint) {
        std::swap(startPoint, endPoint);
    }

    for (int index = startPoint; index < endPoint; index++) {
        if (typedText[index] != m_codeText[index]) {
            if (!m_userPro->isUserMadeMistake()) {
                m_userPro->setIsUserMadeMistake(true);
                m_userPro->setIndexOfFirstMistakeOfUser(index);
                m_mistakeCounter++;
                m_charMistakeCounter[m_codeText[index].unicode()]++;

                // To determine start and end of first word that the user has mistake on it.
                determineNextWord(index);

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
    double speed = (double(m_lengthOfTypedText) / double(WORD_LENGTH))
            / (double(m_triggerCount) / 240);
    m_userSpeed = int(speed);
    if (speed - m_userSpeed > 0.499) {
        m_userSpeed++;
    }
    if (m_userSpeed < 0) {
        m_userSpeed = 0;
    }
}

void Typing::initGlobalVarOfUserProgress() {
    for (int i = 0; i < SIZE_OF_M_CHAR_MISTAKE_COUNTER; i++) {
        m_charMistakeCounter[i] = 0;
    }
    m_mistakeCounter = 0;
    m_userSpeed = 0;
    m_lengthOfTypedText = 0;
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

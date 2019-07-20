/* Typing.io
*
* This file is part of the Typing.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/

#include "userprogress.hpp"

UserProgress::UserProgress(QObject *parent) : QObject(parent) {

}

void UserProgress::setStartIndexOfNextWord(int startIndex) {
    m_startIndexOfNextWord = startIndex;
}

void UserProgress::setEndIndexOfNextWord(int length) {
    m_endIndexOfNextWord = length;
}

void UserProgress::setIsUserMadeMistake(bool isMadeMistake) {
    m_userMadeMistake = isMadeMistake;
}

void UserProgress::setIndexOfFirstMistakeOfUser(int index) {
    m_indexOfFirstMistakeOfUser = index;
}

int UserProgress::getStartIndexOfNextWord() {
    return m_startIndexOfNextWord;
}

int UserProgress::getEndIndexOfNextWord() {
    return m_endIndexOfNextWord;
}

bool UserProgress::isUserMadeMistake() {
    return m_userMadeMistake;
}

int UserProgress::getIndexOfFirstMistakeOfUser() {
    return m_indexOfFirstMistakeOfUser;
}

void UserProgress::setIsEndTest(bool endTest) {
    m_endTest = endTest;
}

bool UserProgress::isEndTest() {
    return m_endTest;
}

void UserProgress::initDateAndTime() {
    QDateTime timeNow = QDateTime::currentDateTime();
    m_dateAndTime = timeNow.toString(QStringLiteral("MM/dd/yy hh:mm:ss"));
}

QString UserProgress::getDateAndTime() {
    return m_dateAndTime;
}

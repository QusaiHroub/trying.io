#include "userprogress.hpp"

UserProgress::UserProgress(QObject *parent) : QObject(parent) {

}

void UserProgress::setStartIndexOfNextWord(int startIndex) {
    m_startIndexOfNextWord = startIndex;
}

void UserProgress::setNextWordLength(int length) {
    m_NextWordLength = length;
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

int UserProgress::getNextWordLength() {
    return m_NextWordLength;
}

bool UserProgress::isUserMadeMistake() {
    return m_userMadeMistake;
}

int UserProgress::getIndexOfFirstMistakeOfUser() {
    return m_indexOfFirstMistakeOfUser;
}

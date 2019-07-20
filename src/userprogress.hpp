/* Typing.io
*
* This file is part of the Typing.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/

#ifndef USERPROGRESS_H
#define USERPROGRESS_H

#include <QObject>

class UserProgress : public QObject {
    Q_OBJECT
private:
    int m_startIndexOfNextWord;
    int m_endIndexOfNextWord;
    int m_indexOfFirstMistakeOfUser;
    bool m_userMadeMistake;
    bool m_endTest;

public:
    explicit UserProgress(QObject *parent = nullptr);
    void setStartIndexOfNextWord(int startIndex);
    void setEndIndexOfNextWord(int length);
    void setIsUserMadeMistake(bool isMadeMistake);
    void setIndexOfFirstMistakeOfUser(int index);
    void setIsEndTest(bool endTest);

signals:

public slots:
    int getStartIndexOfNextWord();
    int getEndIndexOfNextWord();
    bool isUserMadeMistake();
    int getIndexOfFirstMistakeOfUser();
    bool isEndTest();
};

#endif // USERPROGRESS_H

/* Trying.io
*
* This file is part of the Trying.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/

#ifndef USERPROGRESS_H
#define USERPROGRESS_H

// Qt includes

#include <QObject>
#include <QString>
#include <QDateTime>

class UserProgress : public QObject {
    Q_OBJECT
private:
    int m_startIndexOfNextWord;
    int m_endIndexOfNextWord;
    int m_indexOfFirstMistakeOfUser;
    bool m_userMadeMistake;
    bool m_endTest;
    QString m_dateAndTime;

public:
    explicit UserProgress(QObject *parent = nullptr);
    void setStartIndexOfNextWord(int startIndex);
    void setEndIndexOfNextWord(int length);
    void setIsUserMadeMistake(bool isMadeMistake);
    void setIndexOfFirstMistakeOfUser(int index);
    void setIsEndTest(bool endTest);

signals:

public slots:
    QString getDateAndTime();
    int getStartIndexOfNextWord();
    int getEndIndexOfNextWord();
    int getIndexOfFirstMistakeOfUser();
    bool isUserMadeMistake();
    bool isEndTest();
    void initDateAndTime();
    void init();
};

#endif // USERPROGRESS_H

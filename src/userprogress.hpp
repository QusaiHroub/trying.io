#ifndef USERPROGRESS_H
#define USERPROGRESS_H

#include <QObject>

class UserProgress : public QObject {
    Q_OBJECT
private:
    int m_startIndexOfNextWord;
    int m_NextWordLength;
    int m_indexOfFirstMistakeOfUser;
    bool m_userMadeMistake;

public:
    explicit UserProgress(QObject *parent = nullptr);
    void setStartIndexOfNextWord(int startIndex);
    void setNextWordLength(int length);
    void setIsUserMadeMistake(bool isMadeMistake);
    void setIndexOfFirstMistakeOfUser(int index);

signals:

public slots:
    int getStartIndexOfNextWord();
    int getNextWordLength();
    bool isUserMadeMistake();
    int getIndexOfFirstMistakeOfUser();
};

#endif // USERPROGRESS_H

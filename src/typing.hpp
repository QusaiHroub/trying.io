/* Typing.io
*
* This file is part of the Typing.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/

#ifndef TYPING_HPP
#define TYPING_HPP

#include <QObject>
#include <QDebug>
#include <QString>
#include <QTimer>
#include <QThread>
#include <QCharRef>
#include <QChar>

#include "userprogress.hpp"

class Typing: public QObject {
    Q_OBJECT
private:
    const short WORD_LENGTH = 5;
    const short TIMER_START_POINT = 120; // 120 equivalent to 60 second.
    const short SIZE_OF_M_CHAR_MISTAKE_COUNTER = 256;

    QString m_lang;
    QString m_codeText;
    QString m_result;
    int m_triggerCount = TIMER_START_POINT;
    QTimer *m_timer = new QTimer();
    QThread m_qThread;
    QObject *m_timeLabel;
    int m_charMistakeCounter[256] = {};
    int m_mistakeCounter = 0;
    int m_userSpeed = 0;
    int m_lengthOfTypedText = 0;
    QObject *m_userProgress = new UserProgress();
    UserProgress *m_userPro = (UserProgress *)m_userProgress; // I love old-style cast.

public:
    Typing();
    ~Typing();

public slots:
    bool save(QString lang, QString codeText);
    QString getLnag();
    QString getCodeText();
    QString getResult();
    void setTimeLabel(QObject *timeLabel);
    void startTimer();
    void endTimer();
    QObject *getUserProgress();
    void updateUserProgress(QString typedText);
    void calcUserSpeed();
    void initGlobalVarOfUserProgress();
    void determineNextWord(int index);


    // To release memory.
    void freePtr();

private slots:

    // function that executes when the timer ticking
    void timerSlot();
};

#endif // TYPING_HPP

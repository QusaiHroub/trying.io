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

// Qt includes

#include <QObject>
#include <QDebug>
#include <QString>
#include <QTimer>
#include <QThread>
#include <QCharRef>
#include <QChar>

// Local includes

#include "userprogress.hpp"

class Typing: public QObject {
    Q_OBJECT
private:
    const short WORD_LENGTH = 5;
    const short TIMER_END_POINT = 240; // 240 equivalent to 60 second.
    const short SIZE_OF_M_CHAR_MISTAKE_COUNTER = 256;

    QString m_lang;
    QString m_codeText;
    QString m_result;
    int m_triggerCount = 0;
    int m_timerEndPoint = TIMER_END_POINT;
    QTimer *m_timer_0 = new QTimer();
    QThread m_qThread_0;
    QTimer *m_timer_1 = new QTimer();
    QThread m_qThread_1;
    QTimer *m_timer_2 = new QTimer();
    QThread m_qThread_2;
    QObject *m_timeLabel;
    int m_charMistakeCounter[256] = {};
    int m_mistakeCounter = 0;
    int m_userSpeed = 0;
    int m_lengthOfTypedText = 0;
    QObject *m_userProgress = new UserProgress();
    UserProgress *m_userPro = dynamic_cast<UserProgress *>(m_userProgress);
    QObject *m_userSpeedLabel;

public:
    Typing();
    ~Typing();

public slots:
    bool save(QString lang, QString codeText);
    QString getLnag();
    QString getCodeText();
    QString getResult();
    void setTimeLabel(QObject *timeLabel);
    void startTimers();
    void endTimers();
    QObject *getUserProgress();
    void updateUserProgress(QString typedText);
    void calcUserSpeed();
    void initGlobalVarOfUserProgress();
    void determineNextWord(int index);
    void setUserSpeedLabel(QObject *userSpeedLabel);

    // To release memory.
    void freePtr();

private slots:

    // function that executes when the timer 0 ticking
    void timerSlot_0();

    // function that executes when the timer 1 ticking
    void timerSlot_1();

    // function that executes when the timer 2 ticking
    void timerSlot_2();
};

#endif // TYPING_HPP

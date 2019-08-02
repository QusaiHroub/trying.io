/* Trying.io
*
* This file is part of the Trying.io.
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
#include <QDir>

// Local includes

#include "userprogress.hpp"
#include "file.hpp"

class Typing: public QObject {
    Q_OBJECT
private:
    const short WORD_LENGTH = 5;
    const short MINUTE = 60;
    const short SIZE_OF_M_CHAR_MISTAKE_COUNTER = 256;

    QString m_lang;
    QString m_codeText;
    QString m_result;
    QString m_savePath;
    QTimer *m_timer_0 = new QTimer();
    QThread m_qThread_0;
    QTimer *m_timer_1 = new QTimer();
    QThread m_qThread_1;
    QTimer *m_timer_2 = new QTimer();
    QThread m_qThread_2;
    QObject *m_timeLabel;
    QObject *m_userProgress = new UserProgress();
    UserProgress *m_userPro = dynamic_cast<UserProgress *>(m_userProgress);
    QObject *m_userSpeedLabel;
    File *m_selectedFile = nullptr;
    int m_triggerCount = 0;
    int m_timeDuration = MINUTE;
    int m_charMistakeCounter[256] = {};
    int m_mistakeCounter = 0;
    int m_userSpeed = 0;
    int m_lengthOfTypedText = 0;

    void determineNextWord(int index);

public:
    Typing();
    ~Typing();

public slots:
    QString getLnag();
    QString getCodeText();
    QString getResult();
    QString getSavePath();
    QObject *getUserProgress();
    int getTimeDuration();
    bool isTested();

    void setTimeLabel(QObject *timeLabel);
    void setUserSpeedLabel(QObject *userSpeedLabel);
    void setSelectedFile(File *selectedFile);
    void setTimeDuration(int timeDuration);

    bool saveFile(QString name, QString lang, QString codeText);
    void loadFile();

    void startTimers();
    void endTimers();

    void updateUserProgress(QString typedText);
    void calcUserSpeed();
    void initGlobalVarOfUserProgress();

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

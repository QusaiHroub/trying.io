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
#include <QHash>

// Local includes

#include "userprogress.hpp"
#include "file.hpp"

class Typing: public QObject {
    Q_OBJECT
private:
    const short WORD_LENGTH = 5;
    const short MINUTE = 60;

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
    QObject *m_userSpeedLabel;
    QHash<QChar, int> m_charMistakeCounter;
    UserProgress *m_userPro = dynamic_cast<UserProgress *>(m_userProgress);
    File *m_selectedFile = nullptr;
    int m_triggerCount = 0;
    int m_timeDuration = MINUTE;
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
    void setTimeDuration(int timeDurationInMinutes);

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

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

    QString m_codeText;
    QString m_result;
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
    QHash<QString, QString> m_languageTable;
    UserProgress *m_userPro = dynamic_cast<UserProgress *>(m_userProgress);
    TFile *m_selectedFile = nullptr;
    TFolder *m_saveFolder = new TFolder("save", QDir::currentPath());
    int m_triggerCount = 0;
    int m_timeDuration = MINUTE;
    int m_userSpeed = 0;
    int m_lengthOfTypedText = 0;

    void determineNextWord(int index);
    void initLanguageTable();

public:
    Typing();
    ~Typing();

public slots:
    QString getLnag();
    QString getCodeText();
    QString getResult();
    QObject *getSaveFolder();
    QObject *getUserProgress();
    int getTimeDuration();
    bool isTested();

    void setTimeLabel(QObject *timeLabel);
    void setUserSpeedLabel(QObject *userSpeedLabel);
    void setSelectedFile(TFile *selectedFile);
    void setTimeDuration(int timeDurationInMinutes);

    void saveFile(QString name, QString lang, QString codeText);
    void saveFile(QString name, QString lang, QString codeText, QString path);
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

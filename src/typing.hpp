#ifndef TYPING_HPP
#define TYPING_HPP

#include <QObject>
#include <QDebug>
#include <QString>
#include <QTimer>
#include <QThread>

class Typing: public QObject {
    Q_OBJECT
private:
    QString m_lang;
    QString m_codeText;
    QString m_result;
    int m_triggerCount = 120; // 120 equals to 60 second.
    QTimer *m_timer = new QTimer();
    QThread m_qThread;
    QObject *m_timeLabel;

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
    int getStartIndexOfNextWord(QString typedText);

    // Calls after getStartIndexOfNextWord
    int getNextWordLength();
    bool isUserMadeMistake(QString typedText);

    // Calls after isUserMadeMistake
    int getIndexOfFirstMistakeOfUser();

    // To release memory.
    void freePtr();

private slots:

    // function that executes when the timer ticking
    void timerSlot();
};

#endif // TYPING_HPP

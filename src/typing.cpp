#include "typing.hpp"

Typing::Typing() {
    connect(m_timer, SIGNAL(timeout()),
          this, SLOT(timerSlot()));
    m_timer->moveToThread(&m_qThread);
    m_timer->connect(&m_qThread, SIGNAL(started()), SLOT(start()));
    m_timer->connect(&m_qThread, SIGNAL(finished()), SLOT(stop()));
    m_timer->setInterval(500);
    m_timer->stop();
}

Typing::~Typing() {
    endTimer();
    freePtr();
}

void Typing::timerSlot() {
    m_triggerCount--;
    m_timeLabel->setProperty("text", m_triggerCount / 2 + (m_triggerCount & 1));
    if (!m_triggerCount) {
        m_qThread.quit();
        m_qThread.wait();
    }
}

bool Typing::save(QString lang, QString codeText) {
    m_lang = lang;
    m_codeText = codeText;
    return true;
}

QString Typing::getLnag() {
    return m_lang;
}

QString Typing::getCodeText() {
    return m_codeText;
}

QString Typing::getResult() {
    //TODO
    return m_result;
}

void Typing::setTimeLabel(QObject *timeLabel) {
    m_timeLabel = timeLabel;
}

void Typing::startTimer() {
    m_triggerCount = 120;
    m_qThread.start();
}

void Typing::endTimer() {
    m_qThread.quit();
    m_qThread.wait();
}

int Typing::getStartIndexOfNextWord(QString typedText) {
    //TODO
}

int Typing::getNextWordLength() {
    //TODO
}

bool Typing::isUserMadeMistake(QString typedText) {
    //TODO
}

int Typing::getIndexOfFirstUserMisatke() {
    //TODO
}


void Typing::freePtr() {
    delete m_timer;
    delete m_timeLabel;
}

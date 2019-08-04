/* Trying.io
*
* This file is part of the Trying.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/

#ifndef FILE_HPP
#define FILE_HPP

#include <QObject>
#include <QFile>
#include <QString>
#include <QTextStream>
#include <QVariantList>
#include <QDirIterator>

class File : public QObject {
    Q_OBJECT
private:
    QString m_nameOfFile;
    QString m_pathOfFile;

public:
    File();
    File(QString name, QString path, QObject *parent = nullptr);
    ~File();

signals:

public slots:
    void initFile(QString name, QString path);

    QString getName();
    QString getPath();
    QString getFullPath();
};

class TFile: public File {
    Q_OBJECT
private:
    QString m_contentOfFile;
    QString m_extensionOfFile;
    QFile *m_file = nullptr;

public:
    TFile();
    TFile(QString name, QString extension, QString path, QObject *parent = nullptr);
    ~TFile();

public slots:
    void initFile(QString extension);

    void loadAll();
    void saveFile();

    QString getContent();
    QString getExtension();
    QString getFullPath();

    void setContent(QString content);
    void append(QString content);

    void clear();
};

class TFolder: public File {
    Q_OBJECT
private:
    QStringList m_extensionList = {"*.c", "*.h", "*.cc", "*.cpp", "*.cxx", "*.c++",
                                   "*.hh", "*.hpp", "*.hxx", "*.h++", "*.java"};

public:
    TFolder();
    TFolder(QString name, QString path, QObject *parent = nullptr);

public slots:
    QVariantList scanForFiles();
    QVariantList scanForDirectories();

    static void createFolder(QString path);
    static void removeFolder(QString path);
    void create();
    void remove();
};

#endif // FILE_HPP

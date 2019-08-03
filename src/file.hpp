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
    QString m_contentOfFile;
    QString m_nameOfFile;
    QString m_extensionOfFile;
    QString m_pathOfFile;
    QFile *m_file = nullptr;
    bool m_type = true;
    QStringList m_extensionList = {"*.c", "*.h", "*.cc", "*.cpp", "*.cxx", "*.c++",
                                   "*.hh", "*.hpp", "*.hxx", "*.h++", "*.java"};

public:
    explicit File(QObject *parent = nullptr);
    File(QString name, QString extension, QString path, bool isFile = true, QObject *parent = nullptr);
    ~File();

signals:

public slots:
    void initFile(QString name, QString extension, QString path, bool isFile = true);

    void loadAll();
    void saveFile();
    QVariantList scanForFiles();
    QVariantList scanForDirectories();

    static void createFolder(QString path);
    static void removeFolder(QString path);
    void create();
    void remove();

    QString getContent();
    QString getName();
    QString getPath();
    QString getFullPath();
    QString getExtension();
    bool isFile();

    void setContent(QString content);
    void append(QString content);

    void clear();
};

#endif // FILE_HPP

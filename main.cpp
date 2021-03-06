/****************************************************************************
**
** Copyright (C) 2012 Nokia Corporation and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "qmlapplicationviewer.h"
#if (QT_VERSION >= QT_VERSION_CHECK(5,0,0))
#include <QApplication>
#else
#include <QtGui/QApplication>
#endif
#include <QtDeclarative/QDeclarativeContext>
#include <QtDeclarative/QDeclarativeEngine>
#include <QDesktopWidget>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    bool isSmallResolution = false;
    QString current;
    QString currentName;
    QString currentVal;
    int idxOf=0;

    /* Parse command line arguments */
    for(int i=0; i<argc; i++)
    {
        current = argv[i];
        idxOf = current.indexOf("=");
        if(idxOf == -1)
        {
            currentName = current;
            currentVal = QString();
        }else{
            currentName = current.left(idxOf);
            currentVal = current.mid(idxOf+1);
        }

        if(currentName.count())
        {

            if(currentName.contains(QString("smallresolution")))
            {
                // use small resolution
                isSmallResolution = true;
            }
        }
    }

    QApplication app(argc, argv);

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.engine()->rootContext()->setContextProperty("smallResolution", isSmallResolution);
    viewer.setMainQmlFile(QLatin1String("qml/samegame/samegame.qml"));
    viewer.setFixedSize(app.desktop()->size());
    viewer.showFullScreen();
    qApp->setOverrideCursor( QCursor( Qt::BlankCursor ) );

    return app.exec();
}

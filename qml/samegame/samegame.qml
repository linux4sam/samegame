/****************************************************************************
**
** Copyright (C) 2012 Nokia Corporation and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/
**
** This file is part of the QtDeclarative module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser General Public
** License version 2.1 as published by the Free Software Foundation and
** appearing in the file LICENSE.LGPL included in the packaging of this
** file. Please review the following information to ensure the GNU Lesser
** General Public License version 2.1 requirements will be met:
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights. These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU General
** Public License version 3.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of this
** file. Please review the following information to ensure the GNU General
** Public License version 3.0 requirements will be met:
** http://www.gnu.org/copyleft/gpl.html.
**
** Other Usage
** Alternatively, this file may be used in accordance with the terms and
** conditions contained in a signed written agreement between you and Nokia.
**
**
**
**
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 1.1
import "SamegameCore"
import "SamegameCore/samegame.js" as Logic

Rectangle {
    id: screen
    width: smallResolution ? 480 : 450; height: smallResolution ? 272 : 450
    property bool inAnotherDemo: false //Samegame often is just plonked straight into other demos

    SystemPalette { id: activePalette }

    Item {
        width: parent.width
        anchors { top: parent.top; bottom: toolBar.top }

        Image {
            id: background
            anchors.fill: parent
            source: "SamegameCore/pics/background.png"
            fillMode: Image.PreserveAspectCrop
        }

        Item {
            id: gameCanvas
            property int score: 0
            property int blockSize: 40

            z: 20; anchors.centerIn: parent
            width: parent.width - (parent.width % blockSize);
            height: parent.height - (parent.height % blockSize);

            MouseArea {
                anchors.fill: parent; onClicked: Logic.handleClick(mouse.x,mouse.y);
            }
        }
    }

    Dialog { id: dialog; anchors.centerIn: parent; z: 21 }

    Dialog {
        id: nameInputDialog

        property int initialWidth: 0
        property alias name: nameInputText.text

        anchors.centerIn: parent
        z: 22;

        Behavior on width {
            NumberAnimation {} 
            enabled: nameInputDialog.initialWidth != 0
        }

        onClosed: {
            if (nameInputText.text != "")
                Logic.saveHighScore(nameInputText.text);
        }
        Text {
            id: dialogText
            anchors { left: nameInputDialog.left; leftMargin: 20; verticalCenter: parent.verticalCenter }
            text: "You won! Please enter your name: "
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (nameInputText.text == "")
                    nameInputText.openSoftwareInputPanel();
                else
                    nameInputDialog.forceClose();
            }
        }

        TextInput {
            id: nameInputText
            anchors { verticalCenter: parent.verticalCenter; left: dialogText.right }
            focus: visible
            autoScroll: false
            maximumLength: 24
            onTextChanged: {
                var newWidth = nameInputText.width + dialogText.width + 40;
                if ( (newWidth > nameInputDialog.width && newWidth < screen.width) 
                        || (nameInputDialog.width > nameInputDialog.initialWidth) )
                    nameInputDialog.width = newWidth;
            }
            onAccepted: {
                nameInputDialog.forceClose();
            }
        }
    }

    Rectangle {
        id: toolBar
        width: parent.width; height: 58
        color: activePalette.window
        anchors.bottom: screen.bottom

        Button {
            id: newGameButton
            anchors { left: parent.left; leftMargin: 3; verticalCenter: parent.verticalCenter }
            text: "New Game" 
            onClicked: Logic.startNewGame()
        }

        Button {
            visible: !inAnotherDemo
            text: "Quit"
            anchors { left: newGameButton.right; leftMargin: 3; verticalCenter: parent.verticalCenter }
            onClicked: Qt.quit();
        }

        Text {
            id: score
            anchors { right: parent.right; rightMargin: 3; verticalCenter: parent.verticalCenter }
            text: "Score: " + gameCanvas.score
            font.bold: true
            font.pixelSize: 24
            color: activePalette.windowText
        }
    }
}

/*
 *  SPDX-FileCopyrightText: 2021 Felipe Kinoshita <kinofhek@gmail.com>
 *  SPDX-FileCopyrightText: 2022 Nate Graham <nate@kde.org>
 *
 *  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard

import org.kde.plasma.welcome as Welcome
import org.kde.plasma.welcome.private as Private

Welcome.Page {
    id: root

    heading: i18nc("@title", "Ahoy, this is openSUSE")
    description: xi18nc("@info:usagetip %1 is the name of the user's distro",
                        "Welcome to the %1 operating system running KDE Plasma!",
                        Welcome.Distro.name)
    
    RowLayout {
       anchors.left: parent.left
       anchors.right: parent.right
       anchors.top: parent.top
       anchors.topMargin: Kirigami.Units.largeSpacing * 8  // <-- Add space here
       spacing: Kirigami.Units.largeSpacing

        // -----------------------
        // Basics Column
        // -----------------------
        ColumnLayout {
            Layout.preferredWidth: root.width / 3
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            spacing: Kirigami.Units.smallSpacing

            // Title
            Text {
                text: "Basics"
                font.bold: true
                font.pointSize: 17
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                color: Kirigami.Theme.textColor
            }

            // Buttons directly under the title
            Rectangle {
                color: "orange"; radius: 4
                Layout.fillWidth: true
                height: 40
                Text { anchors.centerIn: parent; text: "Read me"; color: "white"; font.bold: true }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("https://doc.opensuse.org/")
                }
            }
            Rectangle {
                color: "blue"; radius: 4
                Layout.fillWidth: true
                height: 40
                Text { anchors.centerIn: parent; text: "Documentation"; color: "white"; font.bold: true }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("https://doc.opensuse.org/")
                }
            }
            Rectangle {
                color: "grey"; radius: 6
                Layout.fillWidth: true
                height: 40
                Text { anchors.centerIn: parent; text: "Get software"; color: "white"; font.bold: true }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("https://software.opensuse.org/explore")
                }
            }
        }

        // -----------------------
        // Center Image
        // -----------------------
        ColumnLayout {
            Layout.preferredWidth: root.width / 3
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter   // center vertically
            spacing: Kirigami.Units.smallSpacing

            Image {
                id: image
                source: Private.App.customIntroIcon || "sinking.png"
                fillMode: Image.PreserveAspectFit
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: Math.min(root.height * 0.3, Kirigami.Units.gridUnit * 20)
                Layout.preferredWidth: Layout.preferredHeight
            }
        }

        // -----------------------
        // Support Column
        // -----------------------
        ColumnLayout {
            Layout.preferredWidth: root.width / 3
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            spacing: Kirigami.Units.smallSpacing

            // Title
            Text {
                text: "Support"
                font.bold: true
                font.pointSize: 17
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                color: Kirigami.Theme.textColor
            }

            // Buttons directly under the title
            Rectangle {
                color: "green"; radius: 4
                Layout.fillWidth: true
                height: 40
                Text { anchors.centerIn: parent; text: "Contribute"; color: "white"; font.bold: true }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("https://en.opensuse.org/Portal:How_to_participate")
                }
            }
            Rectangle {
                color: "deepskyblue"; radius: 4
                Layout.fillWidth: true
                height: 40
                Text { anchors.centerIn: parent; text: "Build openSUSE"; color: "white"; font.bold: true }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("https://build.opensuse.org/")
                }
            }
            Rectangle {
                color: "purple"; radius: 4
                Layout.fillWidth: true
                height: 40
                Text { anchors.centerIn: parent; text: "Help by Donation"; color: "white"; font.bold: true }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("https://geekos.org/sponsorship/")
                }
            }
        }
    }
}

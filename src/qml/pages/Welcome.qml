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

import org.kde.plasma.welcome

GenericPage {
    id: root

    heading: i18nc("@title", "Ahoy, this is openSUSE")
    description: xi18nc("@info:usagetip", "We are a global community promoting and developing a Linux distribution and related tools. Our distribution focuses on stability and flexibility, providing you with a platform to Get Things Done.")
    //xi18nc("@info:usagetip %1 is the name of the user's distro", "Welcome to the %1 operating system running KDE Plasma!", Controller.distroName())

    ColumnLayout {
        id: basicsLayout
        Layout.topMargin: Kirigami.Units.largeSpacing
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        spacing: Kirigami.Units.largeSpacing

        Kirigami.Heading {
            id: basicsTitle
            text: i18nc("@title", "Basics")
            level: 2 // Adjusts the size of the heading
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }
        QQC2.Button {
            id: opensuseDocsButton
            Layout.alignment: Qt.AlignHCenter
            text: i18nc("@action:button", "Documentation")
            icon.name: "document-open"
            onClicked: Qt.openUrlExternally("https://doc.opensuse.org/")
        }
        QQC2.Button {
            id: getSoftware
            Layout.topMargin: Kirigami.Units.largeSpacing
            text: i18nc("@action:button", "Get Software")
            icon.name: "document-open"
            onClicked: Qt.openUrlExternally("https://software.opensuse.org/explore")
        }

    },
    
    ]

        /*Kirigami.UrlButton {
            id: plasmaLink
            Layout.topMargin: Kirigami.Units.largeSpacing
            text: i18nc("@action:button", "Learn more about the KDE community")
            url: "https://community.kde.org/Welcome_to_KDE?source=plasma-welcome"
        },
        Kirigami.UrlButton {
            id: distroUrl
            Layout.topMargin: Kirigami.Units.largeSpacing
            text: i18nc("@action:button %1 is the name of the user's distro", "Learn more about %1", Controller.distroName())
            url: Controller.distroUrl()
            visible: Controller.distroUrl().length > 0
        }*/

    ColumnLayout {
        anchors.centerIn: parent
        height: Math.min(parent.height, Kirigami.Units.gridUnit * 17)
        spacing: Kirigami.Units.smallSpacing

        Loader {
            id: imageContainer

            readonly property bool isImage:
                // Image path in the file
                //Controller.customIntroIcon.startsWith("file:/") ||
                // Our default image
                Controller.customIntroIcon.length === 0

            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            Layout.maximumWidth: root.width

            sourceComponent: isImage ? imageComponent : iconComponent

            Component {
                id: imageComponent

                Image {
                    id: image
                    source: "sinking.png"
                    fillMode: Image.PreserveAspectFit

                    Kirigami.PlaceholderMessage {
                        width: root.width - (Kirigami.Units.largeSpacing * 4)
                        anchors.centerIn: parent
                        text: i18nc("@title", "Image loading failed")
                        explanation: xi18nc("@info:placeholder", "Could not load <filename>%1</filename>. Make sure it exists.", Controller.customIntroIcon)
                        visible: image.status == Image.Error
                    }
                }
            }

            Component {
                id: iconComponent

                Kirigami.Icon {
                    implicitWidth: Kirigami.Units.iconSizes.enormous * 2
                    implicitHeight: implicitWidth
                    source: Controller.customIntroIcon || "kde"
                }
            }

            HoverHandler {
                id: hoverhandler
                cursorShape: Qt.PointingHandCursor
            }
            TapHandler {
                id: tapHandler
                property string url: Controller.customIntroIconLink || distroUrl.url
                onTapped: Qt.openUrlExternally(url)
            }
            QQC2.ToolTip {
                visible: hoverhandler.hovered
                text: i18nc("@action:button clicking on this takes the user to a web page", "Visit %1", tapHandler.url)
            }
        }

        /*QQC2.Label {
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: Math.round(Math.max(root.width / 2, imageContainer.implicitWidth / 2))
            text: Controller.customIntroIconCaption || i18nc("@info", "The is openSUSE!")
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
        }*/
    }
}

import QtQuick 2.0
import Felgo 3.0
import QtMultimedia 5.12
import QZXing 3.1 // barcode scanning

Page {
    title: "Search book"

    Component.onCompleted: initializeScanner()
    signal tagFound(string tag)

    // when tag was found, try loading book
    onTagFound: {
        window.busy = true
        captureText.visible = false
        captureZone.color = "green"
        console.log(tag + " | " + decoder.foundedFormat() + " | " + decoder.charSet());

    }

    Item {
        anchors.fill: parent

        // initialize capture zone size
        Component.onCompleted: {
            captureZone.width = Qt.binding(function() { return videoOutput.contentRect.width / 2 })
            captureZone.height = Qt.binding(function() { return videoOutput.contentRect.height / 4 })
        }

        Camera {
            id:camera
            focus {
                focusMode: CameraFocus.FocusContinuous
                focusPointMode: CameraFocus.FocusPointAuto
            }
        }

        VideoOutput {
            id: videoOutput
            source: camera
            anchors.fill: parent
            autoOrientation: true
            fillMode: VideoOutput.PreserveAspectCrop
            filters: [ zxingFilter ]
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    camera.focus.customFocusPoint = Qt.point(mouse.x / width,  mouse.y / height);
                    camera.focus.focusMode = CameraFocus.FocusMacro;
                    camera.focus.focusPointMode = CameraFocus.FocusPointCustom;
                }
            }
        }

        // Barcode Scanner Video Filter
        QZXingFilter {
            id: zxingFilter
            // setup capture area
            captureRect: {
                videoOutput.contentRect;
                videoOutput.sourceRect;
                return videoOutput.mapRectToSource(videoOutput.mapNormalizedRectToItem(Qt.rect(
                                                                                           0.25, 0.25, 0.5, 0.5
                                                                                           )));
            }
            // set up decoder
            decoder {
                id: decoder
                enabledDecoders: QZXing.DecoderFormat_EAN_13
                onTagFound: {
                    console.log(tag + " | " + decoder.foundedFormat() + " | " + decoder.charSet());
                    var tagInfo = tag

                    zxingFilter.active = false
                    // window.busy = true
                    captureText.visible = false
                    captureZone.color = "green"
                }
                tryHarder: false
            }
        }
    }

    // Scanner UI
    Item {
        id: scannerUI
        anchors.fill: parent
        z: 1

        // Capture Zone Overlay
        Rectangle {
            id: captureZone
            color: "red"
            opacity: 0.2
            anchors.centerIn: parent
        }

        // Capture Text Overlay
        AppText {
            id: captureText
            anchors.centerIn: parent
            color: "white"
            text: "[place ISBN code\nin this area\nBetter use in landscape]"
            font.pixelSize: sp(12)
            horizontalAlignment: AppText.AlignHCenter
            font.bold: true
        }

        // Activity Indicator Overlay
        AppActivityIndicator {
            animating: window.busy
            visible: animating
            anchors.centerIn: parent
            color: "white"
        }
    }

    function initializeScanner() {
        // reset UI

        captureText.visible = true
        captureZone.color = "red"
        zxingFilter.active = true
    }
}






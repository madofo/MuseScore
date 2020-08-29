import QtQuick 2.9
import QtQuick.Layouts 1.3

import MuseScore.Ui 1.0
import MuseScore.UiComponents 1.0
import MuseScore.Instruments 1.0

Rectangle {
    id: root

    property bool isInstrumentsChosen: instrumentsModel.selectedInstruments.length > 0
    property bool canSelectMultipleInstruments: true

    function selectedInstruments() {
        var instruments = instrumentsModel.selectedInstruments
        var result = []

        for (var i = 0; i < instruments.length; ++i) {
            result.push(instruments[i].config)
        }

        return result
    }

    color: ui.theme.backgroundPrimaryColor

    InstrumentListModel {
        id: instrumentsModel
    }

    Component.onCompleted: {
        instrumentsModel.load(canSelectMultipleInstruments)
        Qt.callLater(familyView.selectFirstGroup)
    }

    RowLayout {
        anchors.fill: parent

        spacing: 12

        FamilyView {
            id: familyView

            Layout.preferredWidth: root.canSelectMultipleInstruments ? root.width / 4 : undefined
            Layout.fillWidth: !root.canSelectMultipleInstruments
            Layout.fillHeight: true

            families: instrumentsModel.families
            groups: instrumentsModel.groups

            onFamilySelected: {
                instrumentsModel.selectFamily(familyId)
                Qt.callLater(selectFirstGroup)
            }

            onGroupSelected: {
                instrumentsModel.selectGroup(groupId)
                Qt.callLater(instrumentsView.selectFirstInstrument)
            }

            Connections {
                target: instrumentsModel

                function onSelectedFamilyChanged(family) {
                    familyView.setFamily(family)
                }
            }
        }

        SeparatorLine { orientation: Qt.Vertical }

        InstrumentsView {
            id: instrumentsView

            Layout.preferredWidth: root.canSelectMultipleInstruments ? root.width / 4 : undefined
            Layout.fillWidth: !root.canSelectMultipleInstruments
            Layout.fillHeight: true

            instruments: instrumentsModel.instruments

            onSearchChanged: {
                instrumentsModel.setSearchText(search)
                Qt.callLater(familyView.selectFirstGroup)
            }

            onSelectInstrumentRequested: {
                instrumentsModel.selectInstrument(instrumentId, transposition)
            }

            onInstrumentClicked: {
                if (root.canSelectMultipleInstruments) {
                    return
                }

                instrumentsModel.selectInstrument(instrument.id)
            }
        }

        SeparatorLine { orientation: Qt.Vertical }

        FlatButton {
            visible: root.canSelectMultipleInstruments

            Layout.preferredWidth: 30

            enabled: instrumentsView.isInstrumentSelected

            icon: IconCode.ARROW_RIGHT

            onClicked: {
                var currentSelect = instrumentsView.currentInstrument()
                instrumentsModel.selectInstrument(currentSelect.instrument.id, currentSelect.transposition)
            }
        }

        SeparatorLine { orientation: Qt.Vertical }

        SelectedInstrumentsView {
            id: selectedInstrumentsView

            visible: root.canSelectMultipleInstruments

            Layout.fillWidth: true
            Layout.fillHeight: true

            instruments: instrumentsModel.selectedInstruments
            instrumentOrderTypes: instrumentsModel.instrumentOrderTypes

            onUnselectInstrumentRequested: {
                instrumentsModel.unselectInstrument(id)
            }

            onOrderChanged: {
                instrumentsModel.selectOrderType(id)
            }
        }

        SeparatorLine { orientation: Qt.Vertical }

        Column {
            visible: root.canSelectMultipleInstruments

            Layout.preferredWidth: 30
            Layout.alignment: Qt.AlignVCenter

            spacing: 12

            FlatButton {
                enabled: selectedInstrumentsView.canLiftInstrument
                icon: IconCode.ARROW_UP

                onClicked: {
                    instrumentsModel.swapSelectedInstruments(selectedInstrumentsView.currentInstrumentIndex,
                                                             selectedInstrumentsView.currentInstrumentIndex - 1)
                    selectedInstrumentsView.currentInstrumentIndex--
                }
            }

            FlatButton {
                enabled: selectedInstrumentsView.canLowerInstrument
                icon: IconCode.ARROW_DOWN

                onClicked: {
                    instrumentsModel.swapSelectedInstruments(selectedInstrumentsView.currentInstrumentIndex,
                                                             selectedInstrumentsView.currentInstrumentIndex + 1)
                    selectedInstrumentsView.currentInstrumentIndex++
                }
            }
        }
    }
}
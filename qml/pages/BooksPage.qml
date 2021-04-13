import QtQuick 2.0
import Felgo 3.0

/*

// EXAMPLE USAGE:
// add the following piece of code inside your App { } to display the List Page

Books {

}

*/

ListPage {
    id: booksPage
    title: "Books"

    rightBarItem: NavigationBarRow {

        // add new book
        IconButtonBarItem {
            icon: IconType.plus
            showItem: showItemAlways
            onClicked: {
                booksPage.navigationStack.popAllExceptFirstAndPush(cameraComponent, {})
            }
        }
    }


    model: [{ type: "Fruits", text: "Banana" },
        { type: "Fruits", text: "Apple" },
        { type: "Vegetables", text: "Potato" }]

    section.property: "type"

    Component {
        id: cameraComponent
        CameraPage {

        }
    }
}

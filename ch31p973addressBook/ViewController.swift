
import UIKit
import Contacts
import ContactsUI



class ViewController : UIViewController, CNContactPickerDelegate, CNContactViewControllerDelegate {
    

    func contactViewController(vc: CNContactViewController, didCompleteWithContact con: CNContact?) {
        print(con)
    }
    
    func contactViewController(vc: CNContactViewController, shouldPerformDefaultActionForContactProperty prop: CNContactProperty) -> Bool {
        return false
    }
    
    @IBAction func doUnknownPerson (sender:AnyObject!) {
        CNContactStore().requestAccessForEntityType(.Contacts) {ok, err in
            guard ok else {return} // example pointless without access
            dispatch_async(dispatch_get_main_queue()) {self.demonstrateTheBug()}
        }
    }
    
    func demonstrateTheBug() {
        let con = CNMutableContact()
        con.givenName = "Johnny"
        con.familyName = "Appleseed"
        con.phoneNumbers.append(CNLabeledValue(label: "woods", value: CNPhoneNumber(stringValue: "555-123-4567")))
        let unkvc = CNContactViewController(forUnknownContact: con)
        unkvc.message = "He knows his trees"
        unkvc.contactStore = CNContactStore()
        unkvc.delegate = self
        unkvc.allowsActions = false
        self.navigationController?.pushViewController(unkvc, animated: true)
        // so what's the problem? am I supposed to show this thing another way?
        // this doesn't work either
        // self.presentViewController(UINavigationController(rootViewController: unkvc), animated:true, completion:nil)
        // and this doesn't work either!
        // self.presentViewController(unkvc, animated:true, completion:nil)
    }



}

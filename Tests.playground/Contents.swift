import Foundation

//var fileName = "20200709_Courseulles_107L_6.5.sbp"
var fileName = "20200906_Cruas_103L_5.7_4.7.SBP"


let fileNameWithoutExtension = fileName.trimmingCharacters(in: .init(charactersIn: ".sbp")).trimmingCharacters(in: .init(charactersIn: ".SBP"))


fileNameWithoutExtension.split(separator: "_")
var boards = [String]()
var sails = [String]()

for str in fileNameWithoutExtension.split(separator: "_") {
    if str.contains("L") && CharacterSet.decimalDigits.contains(str.unicodeScalars.first!) {
        boards.append(String(str))
    } else if str.contains(".") {
        sails.append(String(str))
    }
}

boards
sails

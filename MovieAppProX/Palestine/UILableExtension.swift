//
//  UILableExtension.swift
//  AI_Painting
//
//  Created by Trịnh Xuân Minh on 05/10/2023.
//

import UIKit

extension UILabel {
  var numberOfVisibleLines: Int {
    let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
    let textHeight = sizeThatFits(maxSize).height
    let lineHeight = font.lineHeight
    return Int(textHeight / lineHeight)
  }
  
  var maxNumberOfLines: Int {
    let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
    let text = (text ?? "") as NSString
    let textHeight = text.boundingRect(with: maxSize,
                                       options: .usesLineFragmentOrigin,
                                       attributes: [.font: font!],
                                       context: nil).height
    let lineHeight = font.lineHeight
    return Int(ceil(textHeight / lineHeight))
  }
}

extension UILabel {
  func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else {
        return
      }
      guard let mutableString = self.text else {
        return
      }
      
      let readMoreText: String = trailingText + moreText
      
      let lengthForVisibleString: Int = self.vissibleTextLength
      let trimmedString: String = (mutableString as NSString)
        .replacingCharacters(in: NSRange(location: lengthForVisibleString,
                                         length: (self.text!.count - lengthForVisibleString)),
                             with: "")
      let readMoreLength: Int = (readMoreText.count)
      if trimmedString.count < readMoreLength {
        return
      }
      let trimmedForReadMore: String = (trimmedString as NSString)
        .replacingCharacters(in: NSRange(location: (trimmedString.count - readMoreLength),
                                         length: readMoreLength), with: "") + trailingText
      
      let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore,
                                                       attributes: [NSAttributedString.Key.font: self.font as Any])
      let readMoreAttributed = NSMutableAttributedString(string: moreText,
                                                         attributes: [NSAttributedString.Key.font: moreTextFont,
                                                                      NSAttributedString.Key.foregroundColor: moreTextColor])
      answerAttributed.append(readMoreAttributed)
      self.attributedText = answerAttributed
    }
  }
  
  var vissibleTextLength: Int {
    let font: UIFont = font
    let mode: NSLineBreakMode = lineBreakMode
    let labelWidth: CGFloat = frame.size.width
    let labelHeight: CGFloat = frame.size.height
    let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
    
    let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
    let attributedText = NSAttributedString(string: text!,
                                            attributes: attributes as? [NSAttributedString.Key: Any])
    let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint,
                                                           options: .usesLineFragmentOrigin,
                                                           context: nil)
    
    if boundingRect.size.height > labelHeight {
      var index: Int = 0
      var prev: Int = 0
      let characterSet = CharacterSet.whitespacesAndNewlines
      repeat {
        prev = index
        if mode == NSLineBreakMode.byCharWrapping {
          index += 1
        } else {
          index = (text! as NSString)
            .rangeOfCharacter(from: characterSet,
                              options: [],
                              range: NSRange(location: index + 1, length: text!.count - index - 1))
            .location
        }
      } while index != NSNotFound && index < text!.count && (text! as NSString)
        .substring(to: index)
        .boundingRect(with: sizeConstraint,
                      options: .usesLineFragmentOrigin,
                      attributes: attributes as? [NSAttributedString.Key: Any],
                      context: nil).size.height <= labelHeight
      return prev
    }
    return text!.count
  }
}

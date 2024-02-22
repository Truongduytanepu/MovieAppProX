//
//  LogEventManager.swift
//  AI_Painting
//
//  Created by Trịnh Xuân Minh on 06/11/2023.
//

import Foundation
import FirebaseAnalytics

class LogEventManager {
  static let shared = LogEventManager()
  
  func log(event: Event) {
    Analytics.logEvent(event.name, parameters: event.parameters)
  }
}

enum Event {
  case onboardClickNext
  case onboardClickBegin
  case languageClickSave
  case homeClickHome
  case homeClickGallery
  case homeClickTrending
  case homeClickTry
  case homeClickSettings
  case homeClickUses
  case trendingClickCreate
  case trendingClickBack
  case trendingClickUses
  case cameraClickAllowAccess
  case cameraClickAllowAccessReal
  case requestCameraFail
  case cameraClickAddSound
  case cameraClickEscape
  case cameraClickRemove
  case cameraClickChange
  case cameraClickClock
  case cameraClickVideo
  case cameraClickFilter
  case cameraClickUses
  case usesClickWatchAds
  case usesShowPopFreeUses
  case usesShowPopNoUses
  case usesShowPopLimit
  case filterClick1st
  case filterClickDone
  case soundClickChoose
  case soundClickPlay
  case soundClickEscape
  case soundClickAdd
  case resultDetailClickShare
  case resultClickAddGallery
  case resultClickRetake
  case resultClickHome
  case resultClickBack
  case removeDiscard
  case removeYes
  case resultClickShareTiktok
  case resultClickShareInstagram
  case resultClickShareOther
  case resultClickShareFinish
  case emptyClickCamera
  case galleryClickOption
  case galleryClickOptionSelect
  case galleryClickOptionClear
  case galleryClickSelectDetail
  case galleryClickEscape
  case galleryClickShare
  case itemClickDelete
  case itemClickDeleteDiscard
  case menuClickShare
  case menuClickRate
  case menuClickPolicy
  case menuClickLanguage
  case homeClickBanner
  
  var name: String {
    switch self {
    case .onboardClickNext:
      return "Onboard_Click_Next"
    case .onboardClickBegin:
      return "Onboard_Click_Begin"
    case .languageClickSave:
      return "Language_Click_Save"
    case .homeClickHome:
      return "Home_Click_Home"
    case .homeClickGallery:
      return "Home_Click_Gallery"
    case .homeClickTrending:
      return "Home_Click_Trending"
    case .homeClickTry:
      return "Home_Click_Try"
    case .homeClickSettings:
      return "Home_Click_Settings"
    case .homeClickUses:
      return "Home_Click_Uses"
    case .trendingClickCreate:
      return "Trending_Click_Create"
    case .trendingClickBack:
      return "Trending_Click_Back"
    case .trendingClickUses:
      return "Trending_Click_Uses"
    case .cameraClickAllowAccess:
      return "Camera_Click_Allow_Access"
    case .cameraClickAllowAccessReal:
      return "Camera_Click_Allow_Access_Real"
    case .requestCameraFail:
      return "Request_Camera_Fail"
    case .cameraClickAddSound:
      return "Camera_Click_Add_Sound"
    case .cameraClickEscape:
      return "Camera_Click_Escape"
    case .cameraClickRemove:
      return "Camera_Click_Remove"
    case .cameraClickChange:
      return "Camera_Click_Change"
    case .cameraClickClock:
      return "Camera_Click_Clock"
    case .cameraClickVideo:
      return "Camera_Click_Video"
    case .cameraClickFilter:
      return "Camera_Click_Filter"
    case .cameraClickUses:
      return "Camera_Click_Uses"
    case .usesClickWatchAds:
      return "Uses_Click_Watch_Ads"
    case .usesShowPopFreeUses:
      return "Uses_Show_Pop_Free_Uses"
    case .usesShowPopNoUses:
      return "Uses_Show_Pop_No_Uses"
    case .usesShowPopLimit:
      return "Uses_Show_Pop_Limit"
    case .filterClick1st:
      return "Filter_Click_1st"
    case .filterClickDone:
      return "Filter_Click_Done"
    case .soundClickChoose:
      return "Sound_Click_Choose"
    case .soundClickPlay:
      return "Sound_Click_Play"
    case .soundClickEscape:
      return "Sound_Click_Escape"
    case .soundClickAdd:
      return "Sound_Click_Add"
    case .resultDetailClickShare:
      return "Result_Detail_Click_Share"
    case .resultClickAddGallery:
      return "Result_Click_Add_Gallery"
    case .resultClickRetake:
      return "Result_Click_Retake"
    case .resultClickHome:
      return "Result_Click_Home"
    case .resultClickBack:
      return "Result_Click_Back"
    case .removeDiscard:
      return "Remove_Discard"
    case .removeYes:
      return "Remove_Yes"
    case .resultClickShareTiktok:
      return "Result_Click_Share_Tiktok"
    case .resultClickShareInstagram:
      return "Result_Click_Share_Instagram"
    case .resultClickShareOther:
      return "Result_Click_Share_Other"
    case .resultClickShareFinish:
      return "Result_Click_Share_Finish"
    case .emptyClickCamera:
      return "Empty_Click_Camera"
    case .galleryClickOption:
      return "Gallery_Click_Option"
    case .galleryClickOptionSelect:
      return "Gallery_Click_Option_Select"
    case .galleryClickOptionClear:
      return "Gallery_Click_Option_Clear"
    case .galleryClickSelectDetail:
      return "Gallery_Click_Select_Detail"
    case .galleryClickEscape:
      return "Gallery_Click_Escape"
    case .galleryClickShare:
      return "Gallery_Click_Share"
    case .itemClickDelete:
      return "Item_Click_Delete"
    case .itemClickDeleteDiscard:
      return "Item_Click_Delete_Discard"
    case .menuClickShare:
      return "Menu_Click_Share"
    case .menuClickRate:
      return "Menu_Click_Rate"
    case .menuClickPolicy:
      return "Menu_Click_Policy"
    case .menuClickLanguage:
      return "Menu_Click_Language"
    case .homeClickBanner:
      return "Home_Click_Banner"
    }
  }
  
  var parameters: [String: Any]? {
    return nil
  }
}

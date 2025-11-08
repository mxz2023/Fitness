import { ColorConstants } from "@mxz/component"
import {
  BloodLipidData,
  BloodPressureData,
  BloodSugarData,
  HealthCardDataType,
  UricAcidData,
  WeightData
} from "../models/HealthDataModel"
import { Gender, UserDataModel } from "../models/UserDataModel"
import { BaseInputView } from "../views/subs/BaseInputView"
import { BloodLipidInputView } from "../views/subs/BloodLipidInputView"
import { BloodPressureInputView } from "../views/subs/BloodPressureInputView"
import { BloodSugarInputView } from "../views/subs/BloodSugarInputView"
import { UricAcidInputView } from "../views/subs/UricAcidInputView"
import { WeightInputView } from "../views/subs/WeightInputView"


@CustomDialog
export struct HealthInputDialog {
  controller: CustomDialogController
  showType: HealthCardDataType = HealthCardDataType.Unknown
  nickname?: string
  gender?: Gender
  heightCm?: number
  age?: number
  onUserInfoChange?: (val: UserDataModel) => void
  weightKg?: number
  onWeightChange?: (val: WeightData) => void
  bloodSugarValue?: number
  onBloodSugarChange?: (val: BloodSugarData) => void
  uricAcidValue?: number
  onUricAcidChange?: (val: UricAcidData) => void

  systolic?:number
  diastolic?:number
  onBloodPressureChange?: (val: BloodPressureData) => void

  totalCholesterol?:number
  triglycerides?:number
  hdlCholesterol?:number
  ldlCholesterol?:number
  onBloodLipidChange?: (val: BloodLipidData) => void

  aboutToAppear(): void {

  }

  build() {
    // 遮罩背景半透明
    Column() {
      // 半弹层背景白色
      Column() {
        if (this.showType === HealthCardDataType.BaseInfo) {
          BaseInputView({
            initData: {
              nickname: this.nickname,
              gender: this.gender,
              heightCm: this.heightCm,
              age: this.age,
            } as UserDataModel,
            onSubmit: (data?: UserDataModel) => {
              if (data && this.onUserInfoChange) {
                this.onUserInfoChange(data)
              }
              this.controller.close()
            }
          }).height(350)
        } else if (this.showType === HealthCardDataType.WeightInfo) {
          WeightInputView({
            weightKg: this.weightKg,
            onSubmit: (data?: WeightData) => {
              if (data && this.onWeightChange) {
                this.onWeightChange(data)
              }
              this.controller.close()
            }
          }).height(250)
        } else if (this.showType === HealthCardDataType.BloodSugarInfo) {
          BloodSugarInputView({
            bloodSugarValue: this.bloodSugarValue,
            onSubmit: (data?: BloodSugarData) => {
              if (data && this.onBloodSugarChange) {
                this.onBloodSugarChange(data)
              }
              this.controller.close()
            }
          }).height(300)
        } else if (this.showType === HealthCardDataType.UricAcidInfo) {
          UricAcidInputView({
            inputValue: this.uricAcidValue,
            gender: this.gender,
            onSubmit: (data?: UricAcidData) => {
              if (data && this.onUricAcidChange) {
                this.onUricAcidChange(data)
              }
              this.controller.close()
            }
          }).height(300)
        } else if (this.showType === HealthCardDataType.BloodPressureInfo) {
          BloodPressureInputView({
            systolicValue: this.systolic,
            diastolicValue: this.diastolic,
            onSubmit: (data?: BloodPressureData) => {
              if (data && this.onBloodPressureChange) {
                this.onBloodPressureChange(data)
              }
              this.controller.close()
            }
          }).height(300)
        } else if (this.showType === HealthCardDataType.BloodLipidInfo) {
          BloodLipidInputView({
            totalCholesterol: this.totalCholesterol,
            triglycerides: this.triglycerides,
            hdlCholesterol: this.hdlCholesterol,
            ldlCholesterol: this.ldlCholesterol,
            onSubmit: (data?: BloodLipidData) => {
              if (data && this.onBloodLipidChange) {
                this.onBloodLipidChange(data)
              }
              this.controller.close()
            }
          }).height(400)
        }
      }
      .width('100%')
      .backgroundColor(ColorConstants.White)
    }
    .justifyContent(FlexAlign.End)
    .visibility(Visibility.Visible)
    .backgroundColor(ColorConstants.View_Mask)
    .alignRules({
      top: { anchor: '__container__', align: VerticalAlign.Top },
      bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      left: { anchor: '__container__', align: HorizontalAlign.Start },
      right: { anchor: '__container__', align: HorizontalAlign.End }
    })
  }
}
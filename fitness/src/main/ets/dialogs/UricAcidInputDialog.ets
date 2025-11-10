/**
 * Copyright (c) 2023-2025 Mxz Co., Ltd.
 *
 * @file UricAcidInputView.ets
 * @project FitnessTracker
 * @author vincent_gemini
 * @crateTime 2025-10-04
 * @desc
 */

import { MButton, MTextInput, MTitleBar, AppConstants, ColorConstants } from "@mxz/component"
import { FLabel as MLabel } from '../components/FLabel'

import { UricAcidData } from "../models/HealthDataModel"
import { Gender } from "../models/UserDataModel"
import { UnitConstants } from '../common/HealthTypeDefine';


@CustomDialog
export struct UricAcidInputDialog {
  controller: CustomDialogController
  onSubmit?: (data?: UricAcidData) => void;

  @Prop @Require inputValue: number;
  @Prop @Require gender: Gender;
  @State inputNote: string = '';

  aboutToAppear(): void {

  }

  async saveData() {
    const record: UricAcidData = {
      id: `uricAcid_${Date.now()}`,
      timestamp: Date.now(),
      value:  this.inputValue,
      gender: this.gender ?? Gender.UNKNOWN,
      note: this.inputNote || ''
    }
    if (this.onSubmit) {
      this.onSubmit(record);
    }
  }

  @Builder
  contentBuilder() {
    Column({ space: 4 }) {
      Row({ space: 4 }) {
        MLabel({ Label: "尿酸:" })

        MTextInput({
          type: InputType.NUMBER_DECIMAL,
          text:  `${this.inputValue}`,
          onText: (v: string) => {
            const value = parseFloat(v)
            if (isNaN(value) || value <= 0) {
              return
            }
            this.inputValue = value;
          }
        }).layoutWeight(1)

        MLabel({ Label: UnitConstants.URIC_ACID_UNIT })
      }

      Row({ space: 4 }) {
        MLabel({ Label: "备注:" })

        MTextInput({
          type: InputType.Normal,
          text: this.inputNote,
          onText: (v: string) => {
            this.inputNote = v;
          }
        }).layoutWeight(1)
      }
    }
  }

  build() {
    RelativeContainer() {
      MTitleBar({
        style: 1,
        title: "尿酸信息",
        handleBack: () => {
          if (this.onSubmit) {
            this.onSubmit()
          }
          this.controller.close()
        }
      }).alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      }).id('__nav_title_bar__')

      Row() {
        this.contentBuilder()
      }.alignRules({
        top: { anchor: '__nav_title_bar__', align: VerticalAlign.Bottom },
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      }).margin({
        top: AppConstants.VIEW_SPACE
      })

      // 底部
      Row({ space: AppConstants.VIEW_SPACE }) {
        MButton({
          text: '保存记录',
          bgColor: ColorConstants.Green,
          onClickBlock: () => {
            this.saveData()
          }
        })
      }
      .width('50%')
      .alignRules({
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      })
    }
    .width('100%')
    .height(300)
    .constraintSize({
      maxWidth: 500
    })
    .padding(AppConstants.VIEW_PADDING)
    .borderRadius(AppConstants.VIEW_RADIUS)
    .backgroundColor(ColorConstants.White)
  }
}
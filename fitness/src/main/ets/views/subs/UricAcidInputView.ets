/**
 * Copyright (c) 2023-2025 Mxz Co., Ltd.
 *
 * @file UricAcidInputView.ets
 * @project FitnessTracker
 * @author vincent_gemini
 * @crateTime 2025-10-04
 * @desc
 */

import { MLable, MButton, MTextInput, MTitleBar, AppConstants, ColorConstants } from "@mxz/component"

import { UricAcidData } from "../../models/HealthDataModel"
import { Gender } from "../../models/UserDataModel"
import { UnitConstants } from '../../common/HealthTypeDefine';


@ComponentV2
export struct UricAcidInputView {
  @Event onSubmit: (data?: UricAcidData) => void;
  @Param @Require inputValue: number;
  @Param @Require gender: Gender;
  @Local inputNote: string = '';
  // 本地状态
  @Local private inputText: string = "";

  aboutToAppear(): void {
    this.inputText = `${this.inputValue}`
  }

  async saveData() {
    const value = parseFloat(this.inputText)
    if (isNaN(value) || value <= 0) {
      return
    }
    const record: UricAcidData = {
      id: `uricAcid_${Date.now()}`,
      timestamp: Date.now(),
      value: value,
      gender: this.gender ?? Gender.UNKNOWN,
      note: this.inputNote || ''
    }
    this.onSubmit(record)
  }

  @Builder
  contentBuilder() {
    Column({ space: 4 }) {
      Row({ space: 4 }) {
        MLable({ lable: "尿酸:" })

        MTextInput({
          type: InputType.NUMBER_DECIMAL,
          text: this.inputText,
          onText: (v: string) => {
            this.inputText = v;
          }
        }).layoutWeight(1)

        MLable({ lable: UnitConstants.URIC_ACID_UNIT })
      }

      Row({ space: 4 }) {
        MLable({ lable: "备注:" })

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
          this.onSubmit()
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
    .height('100%')
    .padding(AppConstants.VIEW_PADDING)
    .constraintSize({
      maxWidth: 500
    })
    .backgroundColor(ColorConstants.View_Background_Color)
    .borderRadius(AppConstants.VIEW_RADIUS)
  }
}
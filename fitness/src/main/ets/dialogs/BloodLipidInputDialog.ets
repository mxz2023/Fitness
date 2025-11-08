/**
 * Copyright (c) 2023-2025 Mxz Co., Ltd.
 *
 * @file BloodLipidInputView.ets
 * @project FitnessTracker
 * @author vincent_gemini
 * @crateTime 2025-10-04
 * @desc
 */

import { MButton, MTextInput, MTitleBar, AppConstants, ColorConstants } from "@mxz/component"
import { FLabel as MLabel } from '../components/FLabel'

import { BloodLipidData } from "../models/HealthDataModel"
import { UnitConstants } from '../common/HealthTypeDefine';


@CustomDialog
export struct BloodLipidInputDialog {
  controller: CustomDialogController
  onSubmit?: (data?: BloodLipidData) => void;

  @Prop @Require totalCholesterol: number;
  @Prop @Require triglycerides: number;
  @Prop @Require hdlCholesterol: number;
  @Prop @Require ldlCholesterol: number;


  aboutToAppear(): void {

  }

  private async saveData() {
    if (
      this.totalCholesterol <= 0 ||
      this.triglycerides <= 0 ||
      this.hdlCholesterol <= 0 ||
      this.ldlCholesterol <= 0
    ) {
      return
    }
    const now = Date.now()
    const record: BloodLipidData = {
      id: `bloodLipid_${now}`,
      timestamp: now,
      totalCholesterol: this.totalCholesterol,
      triglycerides: this.triglycerides,
      hdlCholesterol: this.hdlCholesterol,
      ldlCholesterol: this.ldlCholesterol,
      note: ''
    }
    if (this.onSubmit) {
      this.onSubmit(record)
    }
    this.controller.close()
  }

  @Builder
  contentBuilder() {
    Column({ space: 4 }) {
      Row({ space: 4 }) {
        MLabel({ Label: "总胆固醇:" })

        MTextInput({
          type: InputType.NUMBER_DECIMAL,
          text: `${this.totalCholesterol}`,
          onText: (v: string) => {
            const value = parseFloat(v)
            if (isNaN(value) || value <= 0) {
              return
            }
            this.totalCholesterol = value;
          }
        }).layoutWeight(1)

        MLabel({ Label: UnitConstants.CHOLESTEROL_UNIT })
      }

      Row({ space: 4 }) {
        MLabel({ Label: "甘油三酯:" })

        MTextInput({
          type: InputType.NUMBER_DECIMAL,
          text: `${this.triglycerides}`,
          onText: (v: string) => {
            const value = parseFloat(v)
            if (isNaN(value) || value <= 0) {
              return
            }
            this.triglycerides = value;
          }
        }).layoutWeight(1)

        MLabel({ Label: UnitConstants.CHOLESTEROL_UNIT })
      }

      Row({ space: 4 }) {
        MLabel({ Label: "高密度脂蛋白:" })

        MTextInput({
          text: `${this.hdlCholesterol}`,
          type: InputType.NUMBER_DECIMAL,
          onText: (v: string) => {
            const value = parseFloat(v)
            if (isNaN(value) || value <= 0) {
              return
            }
            this.hdlCholesterol = value;
          }
        }).layoutWeight(1)

        MLabel({ Label: UnitConstants.CHOLESTEROL_UNIT })
      }

      Row({ space: 4 }) {
        MLabel({ Label: "低密度脂蛋白:" })

        MTextInput({
          type: InputType.NUMBER_DECIMAL,
          text: `${this.ldlCholesterol}`,
          onText: (v: string) => {
            const value = parseFloat(v)
            if (isNaN(value) || value <= 0) {
              return
            }
            this.ldlCholesterol = value;
          }
        }).layoutWeight(1)

        MLabel({ Label: UnitConstants.CHOLESTEROL_UNIT })
      }
    }
  }

  build() {
    RelativeContainer() {
      MTitleBar({
        style:1,
        title: "血脂信息",
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
    .height('100%')
    .constraintSize({
      maxWidth: 500
    })
    .padding(AppConstants.VIEW_PADDING)
    .borderRadius(AppConstants.VIEW_RADIUS)
  }
}
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
import { FLable as MLable } from '../../components/FLable'

import { BloodLipidData } from "../../models/HealthDataModel"
import { UnitConstants } from '../../common/HealthTypeDefine';


@ComponentV2
export struct BloodLipidInputView {
  @Event onSubmit: (data?: BloodLipidData) => void;
  @Param @Require totalCholesterol: number;
  @Param @Require triglycerides: number;
  @Param @Require hdlCholesterol: number;
  @Param @Require ldlCholesterol: number;
  // 本地状态
  @Local private totalCholesterolText: string = "";
  @Local private triglyceridesText: string = "";
  @Local private hdlCholesterolText: string = "";
  @Local private ldlCholesterolText: string = "";

  aboutToAppear(): void {
    this.totalCholesterolText = `${this.totalCholesterol}`;
    this.triglyceridesText = `${this.triglycerides}`;
    this.hdlCholesterolText = `${this.hdlCholesterol}`;
    this.ldlCholesterolText = `${this.ldlCholesterol}`;
  }

  private async saveData() {
    if (
      this.totalCholesterolText.length <= 0 ||
      this.triglyceridesText.length <= 0 ||
      this.hdlCholesterolText.length <= 0 ||
      this.ldlCholesterolText.length <= 0
    ) {
      return
    }
    const now = Date.now()
    const record: BloodLipidData = {
      id: `bloodLipid_${now}`,
      timestamp: now,
      totalCholesterol: Number(this.totalCholesterolText),
      triglycerides: Number(this.triglyceridesText),
      hdlCholesterol: Number(this.hdlCholesterolText),
      ldlCholesterol: Number(this.ldlCholesterolText),
      note: ''
    }
    this.onSubmit(record)
  }

  @Builder
  contentBuilder() {
    Column({ space: 4 }) {
      Row({ space: 4 }) {
        MLable({ lable: "总胆固醇:" })

        MTextInput({
          type: InputType.NUMBER_DECIMAL,
          text: this.totalCholesterolText,
          onText: (v: string) => {
            this.totalCholesterolText = v;
          }
        }).layoutWeight(1)

        MLable({ lable: UnitConstants.CHOLESTEROL_UNIT })
      }

      Row({ space: 4 }) {
        MLable({ lable: "甘油三酯:" })

        MTextInput({
          type: InputType.NUMBER_DECIMAL,
          text: this.triglyceridesText,
          onText: (v: string) => {
            this.triglyceridesText = v;
          }
        }).layoutWeight(1)

        MLable({ lable: UnitConstants.CHOLESTEROL_UNIT })
      }

      Row({ space: 4 }) {
        MLable({ lable: "高密度脂蛋白:" })

        MTextInput({
          text: this.hdlCholesterolText,
          type: InputType.NUMBER_DECIMAL,
          onText: (v: string) => {
            this.hdlCholesterolText = v;
          }
        }).layoutWeight(1)

        MLable({ lable: UnitConstants.CHOLESTEROL_UNIT })
      }

      Row({ space: 4 }) {
        MLable({ lable: "低密度脂蛋白:" })

        MTextInput({
          type: InputType.NUMBER_DECIMAL,
          text: this.ldlCholesterolText,
          onText: (v: string) => {
            this.ldlCholesterolText = v;
          }
        }).layoutWeight(1)

        MLable({ lable: UnitConstants.CHOLESTEROL_UNIT })
      }
    }
  }

  build() {
    RelativeContainer() {
      MTitleBar({
        style:1,
        title: "血脂信息",
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
    .constraintSize({
      maxWidth: 500
    })
    .padding(AppConstants.VIEW_PADDING)
    .borderRadius(AppConstants.VIEW_RADIUS)
  }
}
/**
 * Copyright (c) 2023-2025 Mxz Co., Ltd.
 *
 * @file BloodPressureInputView.ets
 * @project FitnessTracker
 * @author vincent_gemini
 * @crateTime 2025-10-04
 * @desc
 */

import { MLable, MButton, MTextInput, MTitleBar, AppConstants, ColorConstants } from "@mxz/component";

import { BloodPressureData } from "../../models/HealthDataModel";
import { UnitConstants } from '../../common/HealthTypeDefine';


@ComponentV2
export struct BloodPressureInputView {
  @Event onSubmit: (data?: BloodPressureData) => void;
  @Param @Require systolicValue: number;
  @Param @Require diastolicValue: number;
  // 本地状态
  @Local private systolicText: string = "";
  @Local private diastolicText: string = "";

  aboutToAppear(): void {
    this.systolicText = `${this.systolicValue}`;
    this.diastolicText = `${this.diastolicValue}`;
  }

  private async saveData() {
    const systolicValue = parseFloat(this.systolicText)
    const diastolicValue = parseFloat(this.diastolicText)
    if (isNaN(systolicValue) || systolicValue <= 0 || isNaN(diastolicValue) || diastolicValue <= 0) {
      return
    }

    const now = Date.now();
    const record = new BloodPressureData();
    record.id = `bloodPressure_${now}`;
    record.timestamp = now;
    record.systolic = systolicValue;
    record.diastolic = diastolicValue;
    record.note = '';
    this.onSubmit(record);
  }

  @Builder
  contentBuilder() {
    Column({ space: 4 }) {
      Row({ space: 4 }) {
        MLable({ lable: "收缩压:" })

        MTextInput({
          type: InputType.NUMBER_DECIMAL,
          text: this.systolicText,
          onText: (v: string) => {
            this.systolicText = v
          }
        }).layoutWeight(1)

        MLable({ lable: UnitConstants.BLOOD_PRESSURE_UNIT })
      }

      Row({ space: 4 }) {
        MLable({ lable: "舒张压:" })

        MTextInput({
          type: InputType.NUMBER_DECIMAL,
          text: this.diastolicText,
          onText: (v: string) => {
            this.diastolicText = v
          }
        }).layoutWeight(1)

        MLable({ lable: UnitConstants.BLOOD_PRESSURE_UNIT })
      }
    }
  }

  build() {
    RelativeContainer() {
      MTitleBar({
        style: 1,
        title: "血压信息",
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
    .backgroundColor(ColorConstants.View_Background_Color)
    .borderRadius(AppConstants.VIEW_RADIUS)
  }
}
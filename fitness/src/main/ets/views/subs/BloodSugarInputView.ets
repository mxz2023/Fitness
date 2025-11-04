/**
 * Copyright (c) 2023-2025 Mxz Co., Ltd.
 *
 * @file BloodSugarInputView.ets
 * @project FitnessTracker
 * @author vincent_gemini
 * @crateTime 2025-10-04
 * @desc
 */

import { MLable, MButton, MTextInput, MTitleBar, AppConstants, ColorConstants } from "@mxz/component";

import { BloodSugarData, MeasurementType } from "../../models/HealthDataModel";
import { UnitConstants } from '../../common/HealthTypeDefine';


@ComponentV2
export struct BloodSugarInputView {
  @Event onSubmit: (data?: BloodSugarData) => void;
  @Param @Require bloodSugarValue: number;
  @Param @Require measurementType: MeasurementType;
  // 本地状态
  @Local private bloodSugarText: string = "";
  @Local private measurementText: MeasurementType = MeasurementType.RANDOM;

  aboutToAppear(): void {
    this.bloodSugarText = `${this.bloodSugarValue}`;
    this.measurementText = this.measurementType;
  }

  private async saveData() {
    const value = parseFloat(this.bloodSugarText)
    if (isNaN(value) || value <= 0) {
      return
    }

    const now = Date.now();
    const record: BloodSugarData = {
      id: `bloodSugar_${now}`,
      timestamp: now,
      value: value,
      measurementType: this.measurementType,
      note: ''
    };
    this.onSubmit(record);
  }

  @Builder
  contentBuilder() {
    Column() {
      Row({ space: 4 }) {
        MLable({ lable: "血糖:" })

        MTextInput({
          type: InputType.NUMBER_DECIMAL,
          text: this.bloodSugarText,
          onText: (v: string) => {
            this.bloodSugarText = v;
          }
        }).layoutWeight(1)

        MLable({ lable: UnitConstants.BLOOD_SUGAR_UNIT })
      }

      Row({ space: 4 }) {
        MLable({ lable: "测量类型:" })

        Row({ space: 8 }) {
          Radio({ value: 'FASTING', group: 'bsType' })
            .checked(this.measurementText === MeasurementType.FASTING)
            .onChange((c: boolean) => {
              if (c) {
                this.measurementText = MeasurementType.FASTING;
              }
            })
          Text('空腹')
          Radio({ value: 'AFTER_MEAL', group: 'bsType' })
            .checked(this.measurementText === MeasurementType.AFTER_MEAL)
            .onChange((c: boolean) => {
              if (c) {
                this.measurementText = MeasurementType.AFTER_MEAL;
              }
            })
          Text('餐后')
          Radio({ value: 'RANDOM', group: 'bsType' })
            .checked(this.measurementText === MeasurementType.RANDOM)
            .onChange((c: boolean) => {
              if (c) {
                this.measurementText = MeasurementType.RANDOM;
              }
            })
          Text('随机')
        }
        .width('100%')
      }
      .width('100%')
      .margin({ top: 8 })
    }
  }

  build() {
    RelativeContainer() {
      MTitleBar({
        style: 1,
        title: "血糖信息",
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
/**
 * Copyright (c) 2023-2025 Mxz Co., Ltd.
 *
 * @file BloodSugarInputView.ets
 * @project FitnessTracker
 * @author vincent_gemini
 * @crateTime 2025-10-04
 * @desc
 */

import { MButton, MTextInput, MTitleBar, AppConstants, ColorConstants } from "@mxz/component";
import { FLabel as MLabel } from '../components/FLabel'

import { BloodSugarData, MeasurementType } from "../models/HealthDataModel";
import { UnitConstants } from '../common/HealthTypeDefine';


@CustomDialog
export struct BloodSugarInputDialog {
  controller: CustomDialogController
  onSubmit?: (data?: BloodSugarData) => void;

  @Prop @Require bloodSugarValue: number;
  @Prop measurementType: MeasurementType = MeasurementType.RANDOM;

  aboutToAppear(): void {

  }

  private async saveData() {
    const now = Date.now();
    const record: BloodSugarData = {
      id: `bloodSugar_${now}`,
      timestamp: now,
      value: this.bloodSugarValue,
      measurementType: this.measurementType,
      note: ''
    };
    if (this.onSubmit) {
      this.onSubmit(record);
    }
    this.controller.close();
  }

  @Builder
  contentBuilder() {
    Column() {
      Row({ space: 4 }) {
        MLabel({ Label: "血糖:" })

        MTextInput({
          type: InputType.NUMBER_DECIMAL,
          text: `${this.bloodSugarValue}`,
          onText: (v: string) => {
            const value = parseFloat(v)
            if (isNaN(value) || value <= 0) {
              return
            }
            this.bloodSugarValue = value;
          }
        }).layoutWeight(1)

        MLabel({ Label: UnitConstants.BLOOD_SUGAR_UNIT })
      }

      Row({ space: 4 }) {
        MLabel({ Label: "测量类型:" })

        Row({ space: 8 }) {
          Radio({ value: 'FASTING', group: 'bsType' })
            .checked(this.measurementType === MeasurementType.FASTING)
            .onChange((c: boolean) => {
              if (c) {
                this.measurementType = MeasurementType.FASTING;
              }
            })
          Text('空腹')
          Radio({ value: 'AFTER_MEAL', group: 'bsType' })
            .checked(this.measurementType === MeasurementType.AFTER_MEAL)
            .onChange((c: boolean) => {
              if (c) {
                this.measurementType = MeasurementType.AFTER_MEAL;
              }
            })
          Text('餐后')
          Radio({ value: 'RANDOM', group: 'bsType' })
            .checked(this.measurementType === MeasurementType.RANDOM)
            .onChange((c: boolean) => {
              if (c) {
                this.measurementType = MeasurementType.RANDOM;
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
          if (this.onSubmit) {
            this.onSubmit()
          }
          this.controller.close();
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
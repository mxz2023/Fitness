/**
 * Copyright (c) 2023-2025 Mxz Co., Ltd.
 *
 * @file BloodPressureInputView.ets
 * @project FitnessTracker
 * @author vincent_gemini
 * @crateTime 2025-10-04
 * @desc
 */

import { MButton, MTextInput, MTitleBar, AppConstants, ColorConstants } from "@mxz/component";
import { FLabel as MLabel } from '../components/FLabel'

import { BloodPressureData } from "../models/HealthDataModel";
import { UnitConstants } from '../common/HealthTypeDefine';


@CustomDialog
export struct BloodPressureInputDialog {
  controller: CustomDialogController
  onSubmit?: (data?: BloodPressureData) => void;

  @Prop @Require systolicValue: number;
  @Prop @Require diastolicValue: number;

  aboutToAppear(): void {

  }

  private async saveData() {
    const now = Date.now();
    const record = new BloodPressureData();
    record.id = `bloodPressure_${now}`;
    record.timestamp = now;
    record.systolic = this.systolicValue;
    record.diastolic = this.diastolicValue;
    record.note = '';
    if (this.onSubmit) {
      this.onSubmit(record);
    }
    this.controller.close();
  }

  @Builder
  contentBuilder() {
    Column({ space: 4 }) {
      Row({ space: 4 }) {
        MLabel({ Label: "收缩压:" })

        MTextInput({
          type: InputType.NUMBER_DECIMAL,
          text: `${this.systolicValue}`,
          onText: (v: string) => {
            const value = parseFloat(v)
            if (isNaN(value) || value <= 0) {
              return
            }
            this.systolicValue = value
          }
        }).layoutWeight(1)

        MLabel({ Label: UnitConstants.BLOOD_PRESSURE_UNIT })
      }

      Row({ space: 4 }) {
        MLabel({ Label: "舒张压:" })

        MTextInput({
          type: InputType.NUMBER_DECIMAL,
          text: `${this.diastolicValue}`,
          onText: (v: string) => {
            const value = parseFloat(v)
            if (isNaN(value) || value <= 0) {
              return
            }
            this.diastolicValue = value
          }
        }).layoutWeight(1)

        MLabel({ Label: UnitConstants.BLOOD_PRESSURE_UNIT })
      }
    }
  }

  build() {
    RelativeContainer() {
      MTitleBar({
        style: 1,
        title: "血压信息",
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
/**
 * Copyright (c) 2023-2025 Mxz Co., Ltd.
 *
 * @file WeightInputView.ets
 * @project FitnessTracker
 * @author vincent_gemini
 * @crateTime 2025-10-04
 * @desc
 */

import { MButton, MTextInput, MTitleBar, AppConstants, ColorConstants } from "@mxz/component"
import { FLabel as MLabel } from '../components/FLabel'

import { WeightData } from "../models/HealthDataModel";
import { UnitConstants } from '../common/HealthTypeDefine';


@CustomDialog
export struct WeightInputDialog {
  controller: CustomDialogController
  onSubmit?: (data?: WeightData) => void;

  @Prop @Require weightKg: number;

  aboutToAppear(): void {

  }

  private async saveData() {
    const now = Date.now();
    const record = new WeightData();
    record.id = `weight_${now}`;
    record.timestamp = now;
    record.value = this.weightKg || 0;
    record.note = '';
    if (this.onSubmit) {
      this.onSubmit(record);
    }
    this.controller.close()
  }

  @Builder
  contentBuilder() {
    Column({ space: 4 }) {

      Row({ space: 4 }) {
        MLabel({ Label: "体重:" })

        MTextInput({
          type: InputType.NUMBER_DECIMAL,
          text: `${this.weightKg}`,
          onText: (v: string) => {
            // 数字与小数点输入校验，最多两位小数
            let res: string = v ?? '';
            if (!/^\d*\.?\d*$/.test(res)) {
              return;
            }
            const parts: string[] = res.split('.');
            if (parts.length > 1 && parts[1].length > 2) {
              res = `${parts[0]}.${parts[1].substring(0, 2)}`;
            }
            const value = parseFloat(res)
            if (isNaN(value) || value <= 0) {
              return
            }
            this.weightKg = value;
          }
        }).layoutWeight(1)

        MLabel({ Label: UnitConstants.WEIGHT_UNIT })
      }
    }
  }

  build() {
    RelativeContainer() {
      MTitleBar({
        style: 1,
        title: "体重信息",
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
    .height(250)
    .constraintSize({
      maxWidth: 500
    })
    .padding(AppConstants.VIEW_PADDING)
    .borderRadius(AppConstants.VIEW_RADIUS)
    .backgroundColor(ColorConstants.White)
  }
}
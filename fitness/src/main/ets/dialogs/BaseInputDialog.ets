/**
 * 基本信息输入（Figma 48_31 对齐实现）
 * 灰背景(参考 310x621)、居中白色卡片(265x345, 圆角5)、底部绿色胶囊按钮(224x28)
 */
import { MButton, MRadio, MTextInput, MTitleBar, AppConstants, ColorConstants } from "@mxz/component";
import { UserDataModel, Gender } from "../models/UserDataModel";
import { UnitConstants } from '../common/HealthTypeDefine';
import { FLabel as MLabel } from '../components/FLabel'



@CustomDialog
export struct BaseInputDialog {
  controller: CustomDialogController
  onSubmit?: (data?: UserDataModel) => void

  // 本地状态
  @Prop @Require nickname: string
  @Prop @Require heightCm: number
  @Prop @Require age:number;
  @Prop gender: Gender = Gender.MALE; // 备选：未知/男/女
  @State year: number = 1983

  aboutToAppear(): void {
    const year = new Date().getFullYear()
    if (this.age > 0) {
      this.year = year - this.age
    }
  }

  private buildYears(): string[] {
    const startYear: number = 1900;
    const currentYear: number = new Date().getFullYear();
    const years: string[] = [];
    for (let y: number = startYear; y <= currentYear; y++) {
      years.push(`${y}年`);
    }
    return years;
  }

  @Builder
  contentBuilder() {
    Column({ space: 4 }) {
      // 昵称
      Row({ space: 4 }) {
        MLabel({ Label: '昵称:' })

        MTextInput({
          type: InputType.USER_NAME,
          text: this.nickname,
          onText: (v: string) => {
            this.nickname = v;
          },
          placeholder: '请输入昵称',
        }).layoutWeight(1)
      }

      // 性别
      Row({ space: 4 }) {
        MLabel({ Label: '性别:' })

        Row({ space: AppConstants.VIEW_SPACE }) {
          MRadio({
            titles: "男",
            isChecked: this.gender == Gender.MALE,
            groupName: "genderGroup",
            onChange: (isCheck: boolean) => {
              if (isCheck) {
                this.gender = Gender.MALE
              }
            }
          })
          MRadio({
            titles: "女",
            isChecked: this.gender == Gender.FEMALE,
            groupName: "genderGroup",
            onChange: (isCheck: boolean) => {
              if (isCheck) {
                this.gender = Gender.FEMALE
              }
            }
          })
        }.layoutWeight(1)
      }

      // 出生日期
      Row({ space: 4 }) {
        MLabel({ Label: '出生:' })

        MLabel({ Label: `${this.year}年` })
          .layoutWeight(1)
      }.onClick(() => {
        // 显示日期选择器设置日期
        this.getUIContext().showTextPickerDialog({
          range: this.buildYears(),
          selected: this.buildYears().length - 1,
          defaultPickerItemHeight: 40,
          canLoop: false,
          onAccept: (value: TextPickerResult) => {
            this.year = Number(value.value.slice(0, -1));
          },
          onCancel: () => {
            console.info("TextPickerDialog:onCancel()");
          },
          onChange: (value: TextPickerResult) => {
            console.info("TextPickerDialog:onChange()" + JSON.stringify(value));
          },
          onScrollStop: (value: TextPickerResult) => {
            console.info("TextPickerDialog:onScrollStop()" + JSON.stringify(value));
          },
          onDidAppear: () => {
            console.info("TextPickerDialog:onDidAppear()");
          },
          onDidDisappear: () => {
            console.info("TextPickerDialog:onDidDisappear()");
          },
          onWillAppear: () => {
            console.info("TextPickerDialog:onWillAppear()");
          },
          onWillDisappear: () => {
            console.info("TextPickerDialog:onWillDisappear()");
          }
        });
      })

      // 身高（cm）
      Row({ space: 4 }) {
        MLabel({ Label: '身高:' })

        MTextInput({
          type: InputType.NUMBER_DECIMAL,
          text: `${this.heightCm}`,
          onText: (value: string) => {
            let res = value;
            if (!/^\d*\.?\d*$/.test(res)) {
              return;
            }
            const parts = res.split('.');
            if (parts.length > 1 && parts[1].length > 2) {
              res = `${parts[0]}.${parts[1].substring(0, 2)}`;
            }
            this.heightCm = Number(res) || 0;
          },
          placeholder: '请输入身高（cm）',
        }).layoutWeight(1)

        MLabel({ Label: UnitConstants.HEIGHT_UNIT })
      }
    }
  }

  build() {
    RelativeContainer() {
      MTitleBar({
        style: 1,
        title: "基本信息",
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
            if (this.onSubmit) {
              this.onSubmit({
                nickname: this.nickname?.trim() ?? '',
                gender: this.gender,
                age: (new Date().getFullYear() - this.year),
                heightCm: Number(this.heightCm) || 0
              });
            }
            this.controller.close()
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
    .height(400)
    .constraintSize({
      maxWidth: 500
    })
    .padding(AppConstants.VIEW_PADDING)
    .borderRadius(AppConstants.VIEW_RADIUS)
    .backgroundColor(ColorConstants.White)
  }
}
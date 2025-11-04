import { CommonDefine } from '@mxz/component';
import { HealthOverview } from '@mxz/fitness';

@Entry
@Component
struct Index {
  private pathStack: NavPathStack = new NavPathStack()

  aboutToAppear(): void {
    AppStorage.setOrCreate(CommonDefine.globalPathStackName, this.pathStack);
  }

  build() {
    Navigation(this.pathStack) {
      HealthOverview()
    }
    .title($r('app.string.app_name'))
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .hideBackButton(true)
    .width('100%')
    .height('100%')
  }
}
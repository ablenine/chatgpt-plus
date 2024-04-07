<template>
  <!-- 主容器 -->
  <div class="home">
    <!-- 导航栏容器 -->
    <div class="navigator" style="display: none;">
      <!-- Logo容器 -->
      <div class="logo">
        <!-- 显示Logo图片 -->
        <el-image :src="logo"/>
        <!-- 分割线 -->
        <div class="divider"></div>
      </div>
      <!-- 导航项列表 -->
      <ul class="nav-items">
        <!-- 列表项循环，为每个导航项 -->
        <li v-for="item in navs" :key="item.path">
          <!-- 导航链接，点击时调用changeNav函数，根据当前路径判断是否应用'active'样式 -->
          <a @click="changeNav(item)" :class="item.path === curPath ? 'active' : ''">
            <!-- 显示导航项图标 -->
            <el-image :src="item.icon" :width="20"/>
          </a>
          <!-- 显示导航项名称，根据当前路径判断是否应用'active'样式 -->
          <div :class="item.url === curPath ? 'title active' : 'title'">{{ item.name }}</div>
        </li>
      </ul>
    </div>
    <!-- 主内容区域 -->
    <div class="content">
      <!-- 路由视图，显示当前路由组件 -->
      <router-view v-slot="{ Component }">
        <!-- 过渡动画 -->
        <transition name="move" mode="out-in">
          <!-- 动态组件，根据当前路由渲染对应的组件 -->
          <component :is="Component"></component>
        </transition>
      </router-view>
    </div>
  </div>
</template>


<script setup>
// 引入Vue Router和Vue组合式API函数
import { useRouter } from "vue-router";
import { onMounted, ref } from "vue";
// 引入自定义HTTP请求函数和Element Plus的消息提示组件
import { httpGet } from "@/utils/http";
import { ElMessage } from "element-plus";

// 创建路由实例
const router = useRouter();
// 创建响应式变量
const logo = ref('/images/logo.png'); // logo图片路径
const navs = ref([]); // 导航项数组
// 当前路由路径
const curPath = ref(router.currentRoute.value.path);

// 切换导航项的函数
const changeNav = (item) => {
  curPath.value = item.url;
  router.push(item.url);
};

// 组件挂载时执行的操作
onMounted(() => {
  // 获取系统Logo配置
  httpGet("/api/config/get?key=system").then(res => {
    logo.value = res.data['logo'];
  }).catch(e => {
    ElMessage.error("获取系统配置失败：" + e.message);
  });
  // 获取系统菜单
  httpGet("/api/menu/list").then(res => {
    navs.value = res.data;
  }).catch(e => {
    ElMessage.error("获取系统菜单失败：" + e.message);
  });
});
</script>


<style lang="stylus" scoped>
@import '@/assets/iconfont/iconfont.css';
.home {
  display: flex;
  height 100vh
  width 100%

  .navigator {
    display flex
    flex-flow column
    width 70px
    padding 10px 6px
    border-right: 1px solid #3c3c3c
    background-color: #393939

    .logo {
      display flex
      flex-flow column
      align-items center


      .divider {
        border-bottom 1px solid #4A4A4A
        width 80%
        height 10px
      }
    }

    .nav-items {
      margin-top: 20px;
      padding-left: 10px;
      padding-right: 10px;

      li {
        margin-bottom 15px

        a {
          color #DADBDC
          background-color #40444A
          border-radius 10px
          width 48px
          height 48px
          display flex
          justify-content center
          align-items center
          cursor pointer

          .el-image {
            border-radius 10px
          }

          .iconfont {
            font-size 20px
          }
        }

        a:hover, a.active {
          color #47fff1
        }

        .title {
          font-size: 12px
          padding-top: 5px
          color: #e5e7eb;
          text-align: center;
        }

        .active {
          color #47fff1
        }
      }
    }
  }

  .content {
    width: 100%;
    height: 100vh;
    box-sizing: border-box;
  }

}
</style>

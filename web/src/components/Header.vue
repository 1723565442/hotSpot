<template>
    <div class="header">
        <el-row>
            <el-col :span="22">
                <div class="title">
                    <p>hotSpot后台管理</p>
                </div>
            </el-col>
            <el-col :span="2">
                <div class="r-content">
                    <el-dropdown @command="handleCommand">
                        <span class="el-dropdown-link">
                            <img style="margin-top: 15px; margin-left: 40px;" class="user_img" src="@/assets/logo.png" />
                        </span>
                        <el-dropdown-menu slot="dropdown">
                            <el-dropdown-item command="a">个人信息</el-dropdown-item>
                            <el-button type="text" @click="open">
                                <el-dropdown-item command="b">退出登录</el-dropdown-item>
                            </el-button>
                        </el-dropdown-menu>
                    </el-dropdown>
                </div>
            </el-col>
        </el-row>
    </div>
</template>

<script>
import router from '../router';

export default {
    name: 'Header',
    data() {
        return {
            msg: 'Welcome to Your Vue.js App',
        };
    },
    methods: {
        goToPage(route) {
            if (this.$route.path != route && !(this.$route.path === '/Home' && route === '/')) {
                this.$router.push(route);
            }
        },
        handleCommand(command) {
            if (command === 'a') {
                this.$router.push('/User');
            }
        },
        open() {
            this.$confirm('是否确定退出登录，下次登录依然可以使用本账号', '  提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                this.$store.dispatch('logout');
                this.$message({
                    type: 'success',
                    message: '登出成功!',
                });

                this.$router.push('/Login');
            }).catch(() => {
            });
        },
    },
    components: { router }
}
</script>
  
<style scoped>
.header {
    height: 100%;
    width: 100%;
    padding: 0;
    margin: 0;
}

.title {
    text-align: start;
    margin-left: 20px;
    margin-top: 0;
    font-size: 24px;
}

.r-content {
    padding-right: 20px;

    .user_img {
        width: 40px;
        height: 40px;
        border-radius: 50%;
    }
}
</style>
  
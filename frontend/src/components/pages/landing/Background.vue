<template>
    <div class="background">
        <div class="stars small" />
        <div class="stars medium" />
        <div class="stars large" />
    </div>
</template>

<script lang="ts">
import "@/assets/stars.svg";
import { defineComponent } from "vue";

export default defineComponent({});
</script>

<style scoped lang="scss">
.background {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    overflow: hidden;
}

.stars {
    position: absolute;
    background-repeat: repeat;
    width: 100%;
    height: 100%;
    opacity: 0.5;

    @keyframes movingStars {
        from {
            background-position: 0 0;
        }
        to {
            background-position: 2000px -2000px;
        }
    }

    &.small {
        background: url("/src/assets/stars.svg#Stars");
        background-size: 500px;
        animation: movingStars 150s linear infinite;
    }

    &.medium {
        background: url("/src/assets/stars.svg#Stars");
        background-size: 1000px;
        animation: movingStars 100s linear infinite;
    }

    &.large {
        background: url("/src/assets/stars.svg#Stars");
        background-size: 2000px;
        animation: movingStars 50s linear infinite;
    }
}
</style>

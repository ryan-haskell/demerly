<template>
  <div class="base">
    <div class="pane mobile" v-if="mobile">
      <img class="img"
        @mouseover="hovering.mobile = true"
        @mouseout="hovering.mobile = false"
        :src="mobile"
        @click="modal = mobile"
        :class="{ 'img--hovered': hovering.mobile }"
        :alt="label + ' mobile design'" />
    </div>
    <div class="pane desktop" v-if="desktop">
      <img class="img"
        @mouseover="hovering.desktop = true"
        @mouseout="hovering.desktop = false"
        :src="desktop"
        @click="modal = desktop"
        :class="{ 'img--hovered': hovering.desktop }"
        :alt="label + ' desktop design'" />
    </div>
    <div class="modal" v-if="modal" @click="modal = undefined">
      <div class="modal__img"
        :style="{ 'background-image': 'url(' + modal + ')' }">
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    mobile: String,
    desktop: String,
    label: String
  },
  data: _ => ({
    modal: undefined,
    hovering: {
      mobile: false,
      desktop: false
    }
  }),

}
</script>

<style scoped>
.base {
  display: flex;
  align-items: center;
  max-width: 100%;
  margin-top: 1rem;
  margin-bottom: 2rem;
}
.img {
  width: 100%;
  border: solid 1px #eee;
  border-radius: 2px;
  cursor: zoom-in;
  transition: transform 200ms ease-in-out, box-shadow 200ms ease-in-out, border-color 200ms ease-in-out;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.45);
}
.img--hovered {
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.35);
  transform: translateY(-2px);
}
.pane:not(:first-child) {
  margin-left: 2rem;
}
.mobile {
  flex: 1 1 0px;
}
.desktop {
  flex: 3 1 0px;
}
.modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.75);
  padding: 1rem;
  z-index: 20;
  cursor: zoom-out;
}
.modal__img {
  position: absolute;
  top: 2rem;
  left: 2rem;
  right: 2rem;
  bottom: 2rem;
  background-size: contain;
  background-position: center;
  background-repeat: no-repeat;
}
</style>


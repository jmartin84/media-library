<template>
<section class="grid">
	<media-grid-tile
		v-for="item in media"
		v-bind:key="`${item.id}-${item.name}-${item.releasedOn}`"
		v-bind:data="item"
	/>
</section>
</template>
<style lang="less" scoped>
.grid {
	display: flex;
	justify-content: flex-start;
	flex-wrap: wrap;
	align-items: flex-start;
	padding: 30px;
}
</style>

<script lang="babel">
import {
	GET_MEDIA_ITEMS
} from '../store/getters';


export default {
	computed: {
		media() {
			return this
				.$store
				.getters[GET_MEDIA_ITEMS];
		}
	}
}
</script>

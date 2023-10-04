<template>
  <div>
    <vxe-table
        ref="xTable1"
        border="inner"
        auto-resize
        resizable
        :loading="isLoading"
        :data="items"
        size="small"
        show-header-overflow
        show-overflow
        highlight-hover-row
        :menu-config="{}"
        :print-config="{}"
        :import-config="{}"
        :export-config="{}"
        :checkbox-config="{}"
        @checkbox-change="selectChangeEvent"
        @checkbox-all="selectChangeEvent"
    >
      <vxe-column type="checkbox"  width="40px"></vxe-column>
      <vxe-column
          field="text"
          title="名称">
      </vxe-column>
      <vxe-column
          field="suffixKey"
          title="短键">
      </vxe-column>
      <vxe-column
          field="backgroundColor"
          title="颜色">
        <template #default="{ row }">
          <v-chip
              :color="row.backgroundColor"
              :text-color="$contrastColor(row.backgroundColor)"
              small
          >
            {{ row.backgroundColor }}
          </v-chip>
        </template>
      </vxe-column>
      <vxe-column
          fixed="right"
          align="center"
          title="操作"
          width="200px">
        <template  #default="{ row }">
          <el-button type="text" icon="el-icon-edit" size="small" @click="$emit('edit', row)">
            编辑
          </el-button>
        </template>

      </vxe-column>
    </vxe-table>
<!--  <v-data-table-->
<!--    :value="value"-->
<!--    :headers="headers"-->
<!--    :items="items"-->
<!--    :search="search"-->
<!--    :loading="isLoading"-->
<!--    :loading-text="$t('generic.loading')"-->
<!--    :no-data-text="$t('vuetify.noDataAvailable')"-->
<!--    :footer-props="{-->
<!--      showFirstLastPage: true,-->
<!--      'items-per-page-text': $t('vuetify.itemsPerPageText'),-->
<!--      'page-text': $t('dataset.pageText')-->
<!--    }"-->
<!--    item-key="id"-->
<!--    show-select-->
<!--    @input="$emit('input', $event)"-->
<!--  >-->
<!--    <template #top>-->
<!--      <v-text-field-->
<!--        v-model="search"-->
<!--        :prepend-inner-icon="mdiMagnify"-->
<!--        :label="$t('generic.search')"-->
<!--        single-line-->
<!--        hide-details-->
<!--        filled-->
<!--      />-->
<!--    </template>-->
<!--    <template #[`item.backgroundColor`]="props">-->
<!--      <v-chip-->
<!--        :color="props.item.backgroundColor"-->
<!--        :text-color="$contrastColor(props.item.backgroundColor)"-->
<!--      >-->
<!--        {{ props.item.backgroundColor }}-->
<!--      </v-chip>-->
<!--    </template>-->
<!--    <template #[`item.actions`]="{ item }">-->
<!--      <v-icon small @click="$emit('edit', item)">-->
<!--        {{ mdiPencil }}-->
<!--      </v-icon>-->
<!--    </template>-->
<!--  </v-data-table>-->
  </div>
</template>

<script lang="ts">
import { mdiMagnify, mdiPencil } from '@mdi/js'
import type { PropType } from 'vue'
import Vue from 'vue'
import {Table} from "vxe-table";
import { LabelDTO } from '~/services/application/label/labelData'

export default Vue.extend({
  props: {
    isLoading: {
      type: Boolean,
      default: false,
      required: true
    },
    items: {
      type: Array as PropType<LabelDTO[]>,
      default: () => [],
      required: true
    },
    value: {
      type: Array as PropType<LabelDTO[]>,
      default: () => [],
      required: true
    },
    disableEdit: {
      type: Boolean,
      default: false
    }
  },

  data() {
    return {
      search: '',
      mdiPencil,
      mdiMagnify
    }
  },

  computed: {
    headers() {
      const headers = [
        { text: this.$t('generic.name'), value: 'text', sortable: true },
        { text: this.$t('labels.shortkey'), value: 'suffixKey', sortable: true },
        { text: this.$t('labels.color'), value: 'backgroundColor', sortable: true }
      ]
      if (!this.disableEdit) {
        headers.push({ text: 'Actions', value: 'actions', sortable: false })
      }
      return headers
    }
  },

  methods: {
    selectChangeEvent () {
      this.$emit('select-change', (( this.$refs.xTable1 as Vue) as Table).getCheckboxRecords())
    },
  }
})
</script>

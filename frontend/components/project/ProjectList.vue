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
          field="name"
          sortable
          title="名称">
        <template slot-scope="scope">
          <el-link  type="primary"
                    :underline="false"
                    @click="openObject(scope.row.id)">
            {{ scope.row.name }}
          </el-link>
        </template>
      </vxe-column>
      <vxe-column
          field="description"
          title="描述">
      </vxe-column>
      <vxe-column
          field="projectType"
          sortable
          title="类型">
      </vxe-column>

      <vxe-column
          field="createdAt"
          sortable
          title="创建时间"
          formatter="formatDate">
      </vxe-column>
<!--      <vxe-column-->
<!--          field="author"-->
<!--          sortable-->
<!--          title="作者">-->
<!--      </vxe-column>-->
    </vxe-table>
    <vxe-pager
        background
        size="small"
        :current-page="options.page"
        :page-size="options.itemsPerPage"
        :total="total"
        :page-sizes="[10, 20, 100]"
        :layouts="['PrevPage', 'JumpNumber', 'NextPage', 'FullJump', 'Sizes', 'Total']">
    </vxe-pager>
<!--    <v-data-table-->
<!--        :value="value"-->
<!--        :headers="headers"-->
<!--        :items="items"-->
<!--        :options.sync="options"-->
<!--        :server-items-length="total"-->
<!--        :search="search"-->
<!--        :loading="isLoading"-->
<!--        :loading-text="$t('generic.loading')"-->
<!--        :no-data-text="$t('vuetify.noDataAvailable')"-->
<!--        :footer-props="{-->
<!--      showFirstLastPage: true,-->
<!--      'items-per-page-options': [10, 50, 100],-->
<!--      'items-per-page-text': $t('vuetify.itemsPerPageText'),-->
<!--      'page-text': $t('dataset.pageText')-->
<!--    }"-->
<!--        item-key="id"-->
<!--        show-select-->
<!--        @input="$emit('input', $event)"-->
<!--    >-->
<!--      <template #top>-->
<!--        <v-text-field-->
<!--            v-model="search"-->
<!--            :prepend-inner-icon="mdiMagnify"-->
<!--            :label="$t('generic.search')"-->
<!--            single-line-->
<!--            hide-details-->
<!--            filled-->
<!--        />-->
<!--      </template>-->
<!--      <template #[`item.name`]="{ item }">-->
<!--        <nuxt-link :to="localePath(`/projects/${item.id}`)">-->
<!--          <span>{{ item.name }}</span>-->
<!--        </nuxt-link>-->
<!--      </template>-->
<!--      <template #[`item.createdAt`]="{ item }">-->
<!--      <span>{{-->
<!--          dateFormat(dateParse(item.createdAt, 'YYYY-MM-DDTHH:mm:ss'), 'YYYY/MM/DD HH:mm')-->
<!--        }}</span>-->
<!--      </template>-->
<!--      <template #[`item.tags`]="{ item }">-->
<!--        <v-chip v-for="tag in item.tags" :key="tag.id" outlined v-text="tag.text" />-->
<!--      </template>-->
<!--    </v-data-table>-->
  </div>

</template>

<script lang="ts">
import { mdiMagnify } from '@mdi/js'
import { dateFormat } from '@vuejs-community/vue-filter-date-format'
import { dateParse } from '@vuejs-community/vue-filter-date-parse'
import { Table } from 'vxe-table'
import type { PropType } from 'vue'
import Vue from 'vue'
import { DataOptions } from 'vuetify/types'
import { Project } from '~/domain/models/project/project'

export default Vue.extend({
  props: {
    isLoading: {
      type: Boolean,
      default: false,
      required: true
    },
    items: {
      type: Array as PropType<Project[]>,
      default: () => [],
      required: true
    },
    value: {
      type: Array as PropType<Project[]>,
      default: () => [],
      required: false
    },
    total: {
      type: Number,
      default: 0,
      required: true
    }
  },

  data() {
    return {
      search: this.$route.query.q,
      options: {} as DataOptions,
      mdiMagnify,
      dateFormat,
      dateParse
    }
  },

  computed: {
    headers(): { text: any; value: string; sortable?: boolean }[] {
      return [
        { text: this.$t('generic.name'), value: 'name' },
        { text: this.$t('generic.description'), value: 'description', sortable: false },
        { text: this.$t('generic.type'), value: 'projectType' },
        { text: 'Created', value: 'createdAt' },
        { text: 'Author', value: 'author' },
        { text: 'Tags', value: 'tags', sortable: false }
      ]
    }
  },

  watch: {
    options: {
      handler() {
        this.updateQuery({
          query: {
            limit: this.options.itemsPerPage.toString(),
            offset: ((this.options.page - 1) * this.options.itemsPerPage).toString(),
            q: this.search
          }
        })
      },
      deep: true
    },
    search() {
      this.updateQuery({
        query: {
          limit: this.options.itemsPerPage.toString(),
          offset: '0',
          q: this.search
        }
      })
      this.options.page = 1
    }
  },

  methods: {
    selectChangeEvent () {
      this.$emit('select-change', (( this.$refs.xTable1 as Vue) as Table).getCheckboxRecords())
    },
    openObject(id: string) {
      window.open(this.localePath('/projects/'+id), '_self')
    },
    updateQuery(payload: any) {
      const { sortBy, sortDesc } = this.options
      if (sortBy.length === 1 && sortDesc.length === 1) {
        payload.query.sortBy = sortBy[0]
        payload.query.sortDesc = sortDesc[0]
      } else {
        payload.query.sortBy = 'createdAt'
        payload.query.sortDesc = true
      }
      this.$emit('update:query', payload)
    }
  }
})
</script>

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
          title="文本">
      </vxe-column>
      <vxe-column
          field="meta"
          title="元数据">
        <template slot-scope="scope">
          {{ JSON.stringify(scope.row.meta, null, 4) }}
        </template>
      </vxe-column>
      <vxe-column
          field="isConfirmed"
          title="状态"
          width="100px">
        <template slot-scope="scope">
          <v-chip :color="scope.row.isConfirmed ? 'success' : 'warning'" text small>
            {{ scope.row.isConfirmed ? '已完成' : '进行中' }}
          </v-chip>
        </template>
      </vxe-column>
      <vxe-column
          fixed="right"
          align="center"
          title="操作"
          width="200px">
        <template  #default="{ row, rowIndex }">
          <el-button type="text" icon="el-icon-edit" size="small" @click="$emit('edit', row)">
            编辑
          </el-button>
          <el-button type="text" icon="el-icon-view" size="small" @click="toLabeling(rowIndex)">
            标注
          </el-button>
        </template>

      </vxe-column>
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
<!--  <v-data-table-->
<!--    :value="value"-->
<!--    :headers="headers"-->
<!--    :items="items"-->
<!--    :options.sync="options"-->
<!--    :server-items-length="total"-->
<!--    :search="search"-->
<!--    :loading="isLoading"-->
<!--    :loading-text="$t('generic.loading')"-->
<!--    :no-data-text="$t('vuetify.noDataAvailable')"-->
<!--    :footer-props="{-->
<!--      showFirstLastPage: true,-->
<!--      'items-per-page-options': [10, 50, 100],-->
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
<!--        :label="$t('generic.search') + ' (e.g. label:positive)'"-->
<!--        single-line-->
<!--        hide-details-->
<!--        filled-->
<!--      />-->
<!--    </template>-->
<!--    <template #[`item.isConfirmed`]="{ item }">-->
<!--      <v-chip :color="item.isConfirmed ? 'success' : 'warning'" text small>-->
<!--        {{ item.isConfirmed ? '已完成' : '进行中' }}-->
<!--      </v-chip>-->
<!--    </template>-->
<!--    <template #[`item.text`]="{ item }">-->
<!--      <span class="d-flex d-sm-none">{{ item.text | truncate(50) }}</span>-->
<!--      <span class="d-none d-sm-flex">{{ item.text | truncate(200) }}</span>-->
<!--    </template>-->
<!--    <template #[`item.meta`]="{ item }">-->
<!--      {{ JSON.stringify(item.meta, null, 4) }}-->
<!--    </template>-->
<!--    <template #[`item.assignee`]="{ item }">-->
<!--      <v-combobox-->
<!--        :value="toSelected(item)"-->
<!--        :items="members"-->
<!--        item-text="username"-->
<!--        no-data-text="No one"-->
<!--        multiple-->
<!--        chips-->
<!--        dense-->
<!--        flat-->
<!--        hide-selected-->
<!--        hide-details-->
<!--        small-chips-->
<!--        solo-->
<!--        style="width: 200px"-->
<!--        @change="onAssignOrUnassign(item, $event)"-->
<!--      >-->
<!--        <template #selection="{ attrs, item, parent, selected }">-->
<!--          <v-chip v-bind="attrs" :input-value="selected" small class="mt-1 mb-1">-->
<!--            <span class="pr-1">{{ item.username }}</span>-->
<!--            <v-icon small @click="parent.selectItem(item)"> $delete </v-icon>-->
<!--          </v-chip>-->
<!--        </template>-->
<!--      </v-combobox>-->
<!--    </template>-->
<!--    <template #[`item.action`]="{ item }">-->
<!--      <v-btn class="me-1" small color="primary text-capitalize" @click="$emit('edit', item)"-->
<!--        >Edit</v-btn-->
<!--      >-->
<!--      <v-btn small color="primary text-capitalize" @click="toLabeling(item)">-->
<!--        {{ $t('dataset.annotate') }}-->
<!--      </v-btn>-->
<!--    </template>-->
<!--  </v-data-table>-->
  </div>
</template>

<script lang="ts">
import { mdiMagnify } from '@mdi/js'
import type { PropType } from 'vue'
import Vue from 'vue'
import { DataOptions } from 'vuetify/types'
import {Table} from "vxe-table";
import { ExampleDTO } from '~/services/application/example/exampleData'
import { MemberItem } from '~/domain/models/member/member'

export default Vue.extend({
  props: {
    isLoading: {
      type: Boolean,
      default: false,
      required: true
    },
    items: {
      type: Array as PropType<ExampleDTO[]>,
      default: () => [],
      required: true
    },
    value: {
      type: Array as PropType<ExampleDTO[]>,
      default: () => [],
      required: true
    },
    total: {
      type: Number,
      default: 0,
      required: true
    },
    members: {
      type: Array as PropType<MemberItem[]>,
      default: () => [],
      required: true
    },
    isAdmin: {
      type: Boolean,
      default: false
    }
  },

  data() {
    return {
      search: this.$route.query.q,
      options: {
        page: 1,
        itemsPerPage: 10
      } as DataOptions,
      mdiMagnify
    }
  },

  computed: {
    headers() {
      const headers = [
        {
          text: 'Status',
          value: 'isConfirmed',
          sortable: false
        },
        {
          text: this.$t('dataset.text'),
          value: 'text',
          sortable: false
        },
        {
          text: this.$t('dataset.metadata'),
          value: 'meta',
          sortable: false
        },
        {
          text: this.$t('dataset.action'),
          value: 'action',
          sortable: false
        }
      ]
      if (this.isAdmin) {
        headers.splice(3, 0, {
          text: 'Assignee',
          value: 'assignee',
          sortable: false
        })
      }
      return headers
    }
  },

  watch: {
    options: {
      handler() {
        this.$emit('update:query', {
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
      this.$emit('update:query', {
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

    toLabeling(index: number) {
      console.log(index)
      const offset = (this.options.page - 1) * this.options.itemsPerPage
      const page = (offset + index + 1).toString()
      console.log(page)
      console.log("pagepage")
      this.$emit('click:labeling', { page, q: this.search })
    },

    toSelected(item: ExampleDTO) {
      const assigneeIds = item.assignments.map((assignment) => assignment.assignee_id)
      return this.members.filter((member) => assigneeIds.includes(member.user))
    },

    onAssignOrUnassign(item: ExampleDTO, newAssignees: MemberItem[]) {
      const newAssigneeIds = newAssignees.map((assignee) => assignee.user)
      const oldAssigneeIds = item.assignments.map((assignment) => assignment.assignee_id)
      if (oldAssigneeIds.length > newAssigneeIds.length) {
        // unassign
        for (const assignment of item.assignments) {
          if (!newAssigneeIds.includes(assignment.assignee_id)) {
            this.$emit('unassign', assignment.id)
          }
        }
      } else {
        // assign
        for (const newAssigneeId of newAssigneeIds) {
          if (!oldAssigneeIds.includes(newAssigneeId)) {
            this.$emit('assign', item.id, newAssigneeId)
          }
        }
      }
    }
  }
})
</script>

<template>
  <v-card outlined>
    <v-card-title v-if="isStaff">
      <el-button type="primary"
                 @click.stop="$router.push(localePath('projects/create'))">
        {{ $t('generic.create') }}
      </el-button>
      <el-button type="primary"
                 :disabled="!canClone" @click.stop="clone">
        复制
      </el-button>
      <el-button
        :disabled="!canDelete"
        outlined
        @click.stop="dialogDelete = true"
      >
        {{ $t('generic.delete') }}
      </el-button>
      <v-dialog v-model="dialogDelete">
        <form-delete :selected="selected" @cancel="dialogDelete = false" @remove="remove" />
      </v-dialog>
    </v-card-title>
    <project-list
      :items="projects.items"
      :is-loading="isLoading"
      :total="projects.count"
      @update:query="updateQuery"
      @select-change="selectChange"
    />
  </v-card>
</template>

<script lang="ts">
import _ from 'lodash'
import Vue from 'vue'
import { mapGetters } from 'vuex'
import ProjectList from '@/components/project/ProjectList.vue'
import FormDelete from '~/components/project/FormDelete.vue'
import { Page } from '~/domain/models/page'
import { Project } from '~/domain/models/project/project'
import { SearchQueryData } from '~/services/application/project/projectApplicationService'

export default Vue.extend({
  components: {
    FormDelete,
    ProjectList
  },
  layout: 'projects',

  middleware: ['check-auth', 'auth'],

  data() {
    return {
      dialogDelete: false,
      projects: {} as Page<Project>,
      selected: [] as Project[],
      isLoading: false
    }
  },

  async fetch() {
    this.isLoading = true
    this.projects = await this.$services.project.list(
      this.$route.query as unknown as SearchQueryData
    )
    this.isLoading = false
  },

  computed: {
    ...mapGetters('auth', ['isStaff']),
    canDelete(): boolean {
      return this.selected.length > 0
    },

    canClone(): boolean {
      return this.selected.length === 1
    }
  },

  watch: {
    '$route.query': _.debounce(function () {
      // @ts-ignore
      this.$fetch()
    }, 1000)
  },

  methods: {
    selectChange(selected: Project[]) {
      this.selected = selected
    },
    async remove() {
      await this.$services.project.bulkDelete(this.selected)
      this.$fetch()
      this.dialogDelete = false
      this.selected = []
    },

    async clone() {
      const project = await this.$services.project.clone(this.selected[0])
      this.selected = []
      this.$router.push(this.localePath(`/projects/${project.id}/settings`))
    },

    updateQuery(query: object) {
      this.$router.push(query)
    }
  }
})
</script>

<style scoped>
::v-deep .v-dialog {
  width: 800px;
}
</style>

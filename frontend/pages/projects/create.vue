<template>
  <v-card outlined>
    <v-card-title>{{ $t('overview.createProjectTitle') }}</v-card-title>
    <v-card-text>
      <v-form v-model="valid">
        <project-type-field v-model="editedItem.projectType" />
        <project-name-field v-model="editedItem.name" outlined autofocus />
        <project-description-field v-model="editedItem.description" outlined />
        <tag-list v-model="editedItem.tags" outlined />
        <v-checkbox
          v-if="showExclusiveCategories"
          v-model="editedItem.exclusiveCategories"
          :label="$t('overview.allowSingleLabel')"
        />
<!--        <v-checkbox-->
<!--          v-if="_canDefineLabel"-->
<!--          v-model="editedItem.allowMemberToCreateLabelType"-->
<!--          label="Allow project members to create label types"-->
<!--        />-->
        <template v-if="isSequenceLabelingProject">
          <v-checkbox v-model="editedItem.allowOverlappingSpans" label="允许重叠标注" />
          <v-img
            :src="require('~/assets/project/creation.gif')"
            height="200"
            position="left"
            contain
          />
          <v-checkbox v-model="editedItem.useRelation" label="使用关系标注" />
          <v-checkbox v-model="editedItem.enableGraphemeMode">
            <template #label>
              <div>
                计算
                <v-tooltip bottom>
                  <template #activator="{ on }">
                    <a
                      target="_blank"
                      href="https://unicode.org/reports/tr29/"
                      @click.stop
                      v-on="on"
                    >
                      grapheme clusters
                    </a>
                  </template>
                  Like emoji(🌷, 💩, and 👍), CRLF(\r\n), and so on.
                </v-tooltip>
                为一个字符
              </div>
            </template>
          </v-checkbox>
        </template>
        <random-order-field v-model="editedItem.enableRandomOrder" />
<!--        <sharing-mode-field v-model="editedItem.enableSharingMode" />-->
      </v-form>
    </v-card-text>
    <v-card-actions class="ps-4">
      <v-btn
        :disabled="!valid"
        color="primary"
        style="text-transform: none"
        outlined
        @click="create"
      >
        {{ $t('generic.create') }}
      </v-btn>
    </v-card-actions>
  </v-card>
</template>

<script lang="ts">
import Vue from 'vue'
import ProjectDescriptionField from '~/components/project/ProjectDescriptionField.vue'
import ProjectNameField from '~/components/project/ProjectNameField.vue'
import ProjectTypeField from '~/components/project/ProjectTypeField.vue'
import RandomOrderField from '~/components/project/RandomOrderField.vue'
// import SharingModeField from '~/components/project/SharingModeField.vue'
import TagList from '~/components/project/TagList.vue'
import {
  DocumentClassification,
  ImageClassification,
  SequenceLabeling,
  canDefineLabel
} from '~/domain/models/project/project'

const initializeProject = () => {
  return {
    name: '',
    description: '',
    projectType: SequenceLabeling,
    enableRandomOrder: false,
    enableSharingMode: false,
    exclusiveCategories: false,
    allowOverlappingSpans: false,
    enableGraphemeMode: false,
    useRelation: false,
    tags: [] as string[],
    guideline: '',
    allowMemberToCreateLabelType: false
  }
}

export default Vue.extend({
  components: {
    ProjectTypeField,
    ProjectNameField,
    ProjectDescriptionField,
    RandomOrderField,
    // SharingModeField,
    TagList
  },

  layout: 'projects',

  middleware: ['check-auth', 'auth'],

  data() {
    return {
      valid: false,
      editedItem: initializeProject()
    }
  },

  computed: {
    showExclusiveCategories(): boolean {
      return [DocumentClassification, ImageClassification].includes(this.editedItem.projectType)
    },
    isSequenceLabelingProject(): boolean {
      return this.editedItem.projectType === SequenceLabeling
    },
    _canDefineLabel(): boolean {
      return canDefineLabel(this.editedItem.projectType as any)
    }
  },

  methods: {
    async create() {
      const project = await this.$services.project.create(this.editedItem)
      this.$router.push(`/projects/${project.id}`)
      this.$nextTick(() => {
        this.editedItem = initializeProject()
      })
    }
  }
})
</script>

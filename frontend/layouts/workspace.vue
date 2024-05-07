<template>
  <v-app>
    <v-main class="pb-0">
      <v-container fluid fill-height>
        <v-layout justify-center>
          <v-flex>
            <v-card>
              <v-card-title>
                <el-button @click="toLabeling" type="success">
                  {{ $t('home.startAnnotation') }}
                </el-button>
                <el-button type="primary" @click="$router.push(localePath('/projects'))">
                  {{ $t('header.projects') }}
                </el-button>
                <el-button type="primary"
                    @click="$router.push(localePath(`/projects/${$route.params.id}/dataset`))">
                    {{ $t('dataset.dataset') }}
                </el-button>
                <el-button type="primary"
                  @click="$router.push(localePath(`/projects/${$route.params.id}/labels`))">
                  {{ $t('labels.labels') }}
                </el-button>
              </v-card-title>
            </v-card>
            <nuxt />
          </v-flex>
        </v-layout>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  middleware: ['check-auth', 'auth', 'set-project'],

  data() {
    return {
      drawerLeft: null,
      isProjectAdmin: false
    }
  },

  computed: {
    ...mapGetters('projects', ['currentProject'])
  },

  watch: {
    '$route.query'() {
      this.$services.option.save(this.$route.params.id, this.$route.query)
    }
  },

  async created() {
    const member = await this.$repositories.member.fetchMyRole(this.$route.params.id)
    this.isProjectAdmin = member.isProjectAdmin
  },

  methods: {
    toLabeling() {
      const query = this.$services.option.findOption(this.$route.params.id)
      const link = getLinkToAnnotationPage(this.$route.params.id, this.project.projectType)
      this.$router.push({
        path: this.localePath(link),
        query
      })
    }
  }
}
</script>

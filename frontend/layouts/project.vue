<template>
  <v-app>
    <v-main>
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
                <el-button v-if="$route.path.endsWith('/dataset')" type="primary"
                  @click="$router.push(localePath(`/projects/${$route.params.id}/labels`))">
                  {{ $t('labels.labels') }}
                </el-button>
                  <el-button v-if="$route.path.endsWith('/labels')" type="primary"
                    @click="$router.push(localePath(`/projects/${$route.params.id}/dataset`))">
                    {{ $t('dataset.dataset') }}
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
// import TheHeader from '~/components/layout/TheHeader'

export default {
  // components: {
  //   TheHeader
  // },

  data() {
    return {
      drawerLeft: null,
      isProjectAdmin: false
    }
  },

  computed: {
    ...mapGetters('projects', ['currentProject'])
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
    },
  }
}
</script>
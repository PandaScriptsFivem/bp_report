Vue.createApp({
    data() {
        return {
            Lang: {
                H1: "Report Panel",
                WriteRep: "Write Report",
                CheckReps: "Check The Reports",
                Title: "The Report Subject",
                Description: "The Report Information",
                Goto: "Goto",
                Bring: "Bring",
                BringBack: "Bring Back",
                Submit: "Submit",
                NoReports: "Nincsenek jelentések",
                Close: "Close",
                SearchPlaceholder: "Search reports...",
                NoSearchResults: "No reports match your search",
                SendMessage: "Send Message",
                Message: "Your Message"
            },
            search:"",
            message:"",
            IsAdmin: true,
            Opened: false,
            home:true,
            Report: false,
            Reports: false,
            showReports: false,
            currentReport: {},
            reports: [
                {id:1, title: "Ez egy report", name:"Bandi", info: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam non massa erat. Donec dignissim vestibulum tempus. Aenean purus neque, venenatis convallis vehicula eget, tempor vitae eros. Nam ligula lorem, tristique et tortor vel, elementum bibendum sem. Donec lorem tortor, ornare vitae lacus in, ultrices vulputate lorem. Nam sagittis sed sapien quis sollicitudin. Fusce ac lobortis orci. Pellentesque vel ultrices nisi, sed egestas sapien. Curabitur et est sollicitudin, efficitur sapien vel, dictum risus. Donec sed rutrum purus. Nullam quis fermentum velit."}
            ],
            OpenedPanel:"home",
            currentReportId: null,
            ReportInfo:"",
            ReportTitle:"",
            ReportWriter:""
        }
    },
    computed: {
        filteredList() {
            if (this.search == "") return this.reports;
    
            const lowsearch = this.search.toLowerCase()
    
            return this.reports.filter((reps) => {
                return reps.title.toLowerCase().includes(lowsearch) || 
                       reps.info.toLowerCase().includes(lowsearch) ||
                       reps.name.toLowerCase().includes(lowsearch) ||
                       reps.reportId.toString().includes(lowsearch);
            });
        }
    },
    methods: {
        CloseAll(){
            this.Report = false
            this.home = false
            this.Reports = false
            this.showReports = false
        },
        open(openelm){
            this.CloseAll()
            this[openelm] = true
            if(this.Lang.H1 !== "Report Panel") this.Lang.H1 = "Report Panel"
        },
        toggleTheme() {
            const panel = document.querySelector('.teljes');
            const themeIcon = document.getElementById('theme-icon');
            
            if (panel.classList.contains('dark-mode')) {
                panel.classList.remove('dark-mode');
                panel.classList.add('light-mode');
                themeIcon.classList.remove('bi-sun-fill');
                themeIcon.classList.add('bi-moon-fill');
            } else {
                panel.classList.remove('light-mode');
                panel.classList.add('dark-mode');
                themeIcon.classList.remove('bi-moon-fill');
                themeIcon.classList.add('bi-sun-fill');
            }
        },
        closePanel() {
            const reportpanel = document.querySelector(".teljes")
            reportpanel.style.animation = 'fadeOut 0.5s ease-out forwards'
            setTimeout(() => {
                this.CloseAll()
                this.Opened = false
                fetch(`https://${GetParentResourceName()}/closepanel`)
            }, 500);
        },
        handleKeydown(event) {
            if (event.key === "Escape") {
                this.closePanel();
            }
        },
        OpenReport(report){
            this.open("showReports")

            this.currentReport = report

            this.Lang.H1 = text2
        },
        GotoPlayer(id){
            this.closePanel()
            this.fetchFunction("goto", id)
        },
        BringPlayer(id){
            this.closePanel()
            this.fetchFunction("bring", id)
        },
        BringBack(id){
            this.closePanel()
            this.fetchFunction("bringback", id)
        },
        SendRep(){
            let data = {
                title: input.value,
                info: textarea.value
            }
            fetch(`https://${GetParentResourceName()}/newreport`, {
                method: "POST",
                body: JSON.stringify(data)
            })
            input.value = '';
            textarea.value = '';
            //this.closePanel()
        },
        CloseRep(reportId) {
            fetch(`https://${GetParentResourceName()}/closereport`, {
                method: "POST",
                body: JSON.stringify({
                    reportId: reportId
                })
            }).then(() => {
                this.reports = this.reports.filter(report => report.reportId !== reportId);
            });
        },
        handleMessage(event) {
            if (event.data.type === 'open') {
                document.querySelector(".teljes").style.animation = 'fadeIn 0.5s ease-out forwards';
                this.IsAdmin = event.data.admin || false;
                this.reports = event.data.reports || [];

                this.Opened = true
                this.home = true
              }
              if (event.data.type === 'refresh') {
                this.reports = event.data.reports || [];
              }
        },
        fetchFunction(type, data) {
            fetch(`https://${GetParentResourceName()}/action`, {
                method: "POST",
                body: JSON.stringify({
                    type: type,
                    data: data
                })
            })
        }
    },
    mounted() {
        window.addEventListener("keydown", this.handleKeydown);
        window.addEventListener('message', this.handleMessage);
        window.addEventListener('report:refreshUI', (event) => {
            this.reports = event.detail || [];
        });
    },
    beforeUnmount() {
        window.removeEventListener("keydown", this.handleKeydown);
        window.removeEventListener('message', this.handleMessage);
        window.removeEventListener('report:refreshUI', this.handleRefreshUI);
    }
}).mount("#reportpanel")


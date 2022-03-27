export default {
	state: () => ({
		phone: {
			"options": {
				"number": "(696) 969-6969",
			},
			"phone": {
				// contacts: [
				// 	{ name: "John Doe", icon: "https://variety.com/wp-content/uploads/2020/08/ap_19339677695734.jpg", number: "7583229442", unread: 3 },
				// 	{ name: "Jennie Steele", number: "8613966842", color: "red" },
				// 	{ name: "Nicholas Newton", number: "7136702627" },
				// 	{ name: "Leila Myers", number: "3138294034", unread: 1 },
				// 	{ name: "Clara Colon", number: "9008264950" },
				// 	{ name: "Glenn Martinez", number: "6282398390" },
				// 	{ name: "Clifford Cain", number: "9839093593", color: "green" },
				// 	{ name: "Sue Wallace", number: "8225942684" },
				// 	{ name: "Luella Stevenson", number: "4826982260" },
				// 	{ name: "Pauline Powers", number: "6475068244" },
				// 	{ name: "Brian Collier", number: "5438083342", color: "red" },
				// 	{ name: "Todd Baldwin", number: "7648917198" },
				// 	{ name: "Lillian Ballard", number: "5043496890" },
				// 	{ name: "Roger Cain", number: "3193525100" },
				// 	{ name: "Raymond Shaw", number: "3677048763", color: "red" },
				// 	{ name: "Scott Garner", number: "8135336735" },
				// 	{ name: "Alberta Mendoza", number: "9779694119" },
				// 	{ name: "Hattie Newman", number: "9733924130" },
				// 	{ name: "Rodney McCarthy", number: "5638152045" },
				// 	{ name: "Bobby Morris", number: "4688153697", color: "green" },
				// 	{ name: "Johnny Copeland", number: "3344252487" },
				// 	{ name: "Ophelia Watts", number: "8176414536" },
				// 	{ name: "Florence Lamb", number: "5336729830" },
				// 	{ name: "Billy Pratt", number: "8016686476" },
				// 	{ name: "Joseph Hill", number: "8055108890" },
				// 	{ name: "Mattie Clarke", number: "3893792828", color: "green" },
				// 	{ name: "Garrett Tucker", number: "4137297398" },
				// 	{ name: "William Edwards", number: "7853082240" },
				// 	{ name: "Marvin Harvey", number: "4699615887" },
				// 	{ name: "Olga Perez", number: "4136272878" },
				// 	{ name: "Kenneth Robinson", number: "7715508049" },
				// 	{ name: "Miguel Keller", number: "8227292403" },
				// 	{ name: "Marion Yates", number: "4677694137" },
				// 	{ name: "Trevor Allen", number: "4838756353" },
				// 	{ name: "Jessie Howell", number: "6809528454" },
				// 	{ name: "Jerome Holloway", number: "3283804349", color: "red" },
				// 	{ name: "Aiden Love", number: "6872743802" },
				// 	{ name: "Jason Doyle", number: "4582349583" },
				// 	{ name: "Samuel Garner", number: "9087219355" },
				// 	{ name: "Marian Douglas", number: "8525001582" },
				// 	{ name: "Lola Mullins", number: "3452546110" },
				// 	{ name: "Jerry Soto", number: "4545879048", color: "red" },
				// 	{ name: "Hattie Park", number: "7215855693" },
				// 	{ name: "Cornelia Bennett", number: "7204893567" },
				// 	{ name: "Phillip Carr", number: "6834152122" },
				// 	{ name: "Minerva Elliott", number: "7036583092" },
				// 	{ name: "Landon Stokes", number: "8763825937", color: "green" },
				// 	{ name: "Dale Martinez", number: "4767044878" },
				// 	{ name: "Sadie Parker", number: "4567328239" },
				// 	{ name: "Barry Beck", number: "8486704653" },
				// 	{ name: "Myrtie Becker", number: "4074487082" },
				// 	{ name: "Franklin Hopkins", number: "2057508766" },
				// 	{ name: "Elijah Allen", number: "2369111212" },
				// 	{ name: "Susan Rhodes", number: "5164376555", color: "green" },
				// 	{ name: "Virginia Pope", number: "8379658340" },
				// 	{ name: "Christian Massey", number: "6055117985" },
				// 	{ name: "Dale Nash", number: "5019657523" },
				// 	{ name: "Cynthia Cain", number: "2817786963" },
				// 	{ name: "Marie Welch", number: "4263245053" },
				// ],
			},
			"bleeter": {

			},
		},
	}),
	mutations: {
		setAppData(state, payload) {
			var deviceData = state[payload.device]
			if (!deviceData) {
				deviceData = {}
				state[payload.device] = deviceData
			}

			var appData = deviceData[payload.app]
			if (!appData) {
				appData = {}
				deviceData[payload.app] = appData
			}
	
			Reflect.set(appData, payload.key, payload.value)
		},
		setData(state, payload) {
			Reflect.set(state, payload.device, payload.data)
		},
	}
}
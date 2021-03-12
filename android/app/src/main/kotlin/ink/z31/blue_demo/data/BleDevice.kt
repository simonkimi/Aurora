package ink.z31.blue_demo.data

data class BleDevice(
        val mac: String,
        val name: String


) {
    override fun hashCode(): Int {
        return this.mac.hashCode()
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as BleDevice

        if (mac != other.mac) return false
        if (name != other.name) return false

        return true
    }
}

RSpec.shared_examples "material" do
  it 'delegates container call to container_material join object' do
    material = create(material_model)
    container_material = create(:container_material, material: material)
    expect(container_material.container).to be_present
    expect(material.container).to eq(container_material.container)
  end
end
